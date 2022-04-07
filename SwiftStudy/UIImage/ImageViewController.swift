//
//  ImageViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2021/11/29.
//

import Foundation
import UIKit
import Lottie

class ImageViewController: BaseViewController {
    
//    var contentView = UIView()
//    var imageView = UIImageView(image: UIImage(named: "island"))
//    var imageView2 = UIImageView(image: UIImage(named: "island"))
    
    override func createUI() {
//        addBodyView()
//        addLabel()
        lottie()
    }
    
    func addBodyView() {
        let contentView = UIView()
        let bodyView = UIView()
        bodyView.backgroundColor = .purple
        let imageView = UIImageView(image: UIImage(named: "island"))
        imageView.backgroundColor = .orange
        
        view.addSubview(contentView)
        contentView.addSubview(bodyView)
        bodyView.addSubview(imageView)
        
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        bodyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bodyView.layoutMarginsGuide.snp.bottom)
        }
    }
    
    func addLabel() {
        let label = UILabel()
        label.text = "2022年1月4日，习近平总书记在北京考察2022年冬奥会、冬残奥会筹办备赛工作。这是习近平总书记2022年首次考察，也是总书记第5次实地考察冬奥会筹办备赛工作。北京冬奥会开幕倒计时一个月之际，对压线冲刺的冬奥会筹办工作再动员、再鼓励。"
        label.numberOfLines = 1
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
    
    func lottie() {
        let lot1 = creatLottieView(name:"flow_h")
        view.addSubview(lot1)
        lot1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(lot1.snp.width).multipliedBy(750.0/1624.0)
        }
        
        let lot2 = creatLottieView(name:"flow_v")
        view.addSubview(lot2)
        lot2.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(lot2.snp.width).multipliedBy(1624.0/750.0)
        }
        
        lot1.play()
        lot2.play()
    }
    
    func creatLottieView(name: String) -> AnimationView {
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.backgroundColor = .clear
        return animationView
    }
    
}
