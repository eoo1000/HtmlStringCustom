//
//  ViewController.swift
//  HtmlStringCustom
//
//  Created by eoo on 6/25/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mainColor: UIColor = UIColor(named: "mainColor") else { return }
        label.attributedText = "<color\(mainColor.hexString)><b14>안녕하세요!</b></color>그리고 <r12>안녕!</r> 입니다".htmlString
    }


}

