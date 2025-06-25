//
//  String+Utils.swift
//  PerfectExam
//
//  Created by 유니위즈 on 2022/08/08.
//

import UIKit

extension String {
    func substring(from: Int = 0, to: Int? = nil) -> String {
        let _to = to ?? self.count - 1
        guard from < _to, _to >= 0, _to <= self.count - 1 else { return self }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: _to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
    
    private func setAttributedString(attStr: NSMutableAttributedString, startPattern: String, endPattern: String, key: NSAttributedString.Key) {
        if let start = try? NSRegularExpression(pattern: startPattern), let end = try? NSRegularExpression(pattern: endPattern) {
            let string = attStr.string
            let startMatch = start.matches(in: string, range:NSRange(location: 0, length: string.count))
            let endMatch = end.matches(in: string, range:NSRange(location: 0, length: string.count))
            for i in 0 ..< startMatch.count {
                let start = startMatch[i].range.upperBound
                let end = endMatch[i].range.lowerBound
                var value: Any? = nil
                switch key {
                case .font:
                    let size = (string as NSString).substring(with: startMatch[i].range).castNum
                    if startPattern.contains("b") {
                        value = UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
                    } else if startPattern.contains("m") {
                        value = UIFont.systemFont(ofSize: CGFloat(size), weight: .medium)
                    } else if startPattern.contains("r") {
                        value = UIFont.systemFont(ofSize: CGFloat(size), weight: .regular)
                    }
                case .foregroundColor:
                    let color = (string as NSString).substring(with: startMatch[i].range).substring(from: 6, to: 12)
                    value = UIColor.init(hex: color)
                case .paragraphStyle:
                    let num = (string as NSString).substring(with: startMatch[i].range).castNum
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = CGFloat(num)
                    value = paragraphStyle
                default: return
                }
                guard let value = value else { return }
                attStr.addAttribute(key, value: value, range: NSRange(location: start, length: end - start))
            }
            
            for i in (0 ..< startMatch.count).reversed() {
                attStr.deleteCharacters(in: endMatch[i].range)
                attStr.deleteCharacters(in: startMatch[i].range)
            }
        }
    }
    
    var htmlString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        setAttributedString(attStr: attributedString, startPattern: "(<line[0-9]+.>)", endPattern: "(</line>)", key: .paragraphStyle)
        setAttributedString(attStr: attributedString, startPattern: "(<b[0-9]+.>)", endPattern: "(</b>)", key: .font)
        setAttributedString(attStr: attributedString, startPattern: "(<m[0-9]+.>)", endPattern: "(</m>)", key: .font)
        setAttributedString(attStr: attributedString, startPattern: "(<r[0-9]+.>)", endPattern: "(</r>)", key: .font)
        setAttributedString(attStr: attributedString, startPattern: "(<color#[0-9a-zA-Z]{6}>)", endPattern: "(</color>)", key: .foregroundColor)
        return attributedString
    }
    
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
    
    var castNum: Int {
        Int(self.filter { $0.isNumber }) ?? 0
    }
}
