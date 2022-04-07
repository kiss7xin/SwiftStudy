//
//  PopoverController.swift
//  SwiftStudy
//
//  Created by weixin on 2021/12/3.
//

import UIKit
import Popover
import AMPopTip

class PopoverController: BaseViewController {
    
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Popover按钮", for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        return button
    }()
    
    lazy var popButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("AMPopTip按钮", for: .normal)
        button.addTarget(self, action: #selector(popClick), for: .touchUpInside)
        return button
    }()
    
    lazy var popView = PopView(origin: CGPoint(x: 50, y: 200), width: 200, height: 50)
    
    override func createUI() {
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
        }
        view.addSubview(popButton)
        popButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-150)
            make.centerX.equalToSuperview()
        }

    }
    
    @objc func click() {
        let label = UILabel()
        label.text = "加油加油！！！"
        let aView = UIView()
        aView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }
        
        let width = self.view.frame.width / 4
        aView.frame = CGRect(x: 0, y: 0, width: width, height: 30)
        
        let options: [PopoverOption] = [
            .type(.up),
              .cornerRadius(4),
              .animationIn(0.3),
              .blackOverlayColor(UIColor.clear),
            .arrowSize(CGSize(width: 12, height: 8)),
            .color(.lightGray),
            .sideOffset(16)
        ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, fromView: self.bottomButton)
    }
    
    @objc func popClick() {
        popView.bgView.backgroundColor = UIColor.orange
        popView.popView()
    }
}
