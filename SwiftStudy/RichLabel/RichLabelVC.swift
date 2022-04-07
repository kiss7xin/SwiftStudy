//
//  RichLabelVC.swift
//  SwiftStudy
//
//  Created by weixin on 2022/1/6.
//

import Foundation
import UIKit

class RichLabelVC: BaseViewController {
    
    override func createUI() {
        let label = UILabel()
        label.numberOfLines = 0
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func labelWithTitle(title: String) {
        var attri = NSMutableAttributedString()
        let attch = NSTextAttachment()
        
        let tip = UILabel()
        tip.backgroundColor = .orange
        tip.layer.cornerRadius = 4.0
        tip.text = "单选题"
    }
}
