//
//  UIColor+Hex.swift
//  PerfectExam
//
//  Created by 유니위즈 on 2022/06/30.
//

import UIKit

extension UIColor {
    static let hex_black: String = "#000000"
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    var hexString: String {
        guard let components = self.cgColor.components, components.count > 0 else { return UIColor.hex_black }
        if components.count <= 2 {
            guard let rgb = components.first else { return UIColor.hex_black }
            return String.init(format: "#%02lX%02lX%02lX", lroundf(Float(rgb * 255)), lroundf(Float(rgb * 255)), lroundf(Float(rgb * 255)))
        } else {
            var hexString = "#"
            for (i, component) in components.enumerated() {
                if i != components.count - 1 { hexString.append(String.init(format: "%02lX", lroundf(Float(component * 255)))) }
            }
            return hexString
        }
     }
    
    var alpah: CGFloat {
        guard let components = self.cgColor.components, components.count > 0 else { return 1.0 }
        return components.last ?? 1.0
     }
}
