//
//  NormalPopupView.swift
//  SwiftStudy
//
//  Created by weixin on 2021/12/7.
//

import UIKit
import RxSwift
import RxGesture

class NormalPopupView: PopupMaskView {
    
    let disposeBag = DisposeBag()
    private var navigation: UINavigationController?
    private var text: String = ""
    
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    public lazy var closeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleForAllStates("关闭")
        button.setTitleColorForAllStates(UIColor.black)
        return button
    }()
    lazy var detailTap = UITapGestureRecognizer()
    
    init(text: String, navigation: UINavigationController?) {
        self.text = text
        self.navigation = navigation
        super.init(position: .center)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    static func show(text: String, navigation: UINavigationController?, groupId: String, popupId: Int) -> NormalPopupView {
//        if let window = UIApplication.shared.keyWindow {
//            for view in window.subviews {
//                if let cardView = view as? NormalPopupView {
//                    cardView.dismiss()
//                }
//            }
//        }
        
        let popupModel = PopupDialogModel()
        popupModel.groupId = groupId
        popupModel.popupId = popupId
        
        let view = NormalPopupView(text:text , navigation: navigation)
        view.maskTapClose = false
        view.maskBackgourndColor = UIColor(hex: 0x000000, transparency: 0.6)
        view.showView(popupModel: popupModel)
        return view
    }
    
    override func createUI() {
        
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(textLabel)
        self.contentView.addSubview(closeButton)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(45)
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 46, height: 46))
            make.top.equalTo(textLabel.snp.bottom).offset(24)
            make.centerX.equalTo(textLabel)
            make.bottom.equalToSuperview()
        }
        
        closeButton.addTarget(self, action: #selector(dissmissAction), for: .touchUpInside)
        
        textLabel.addGestureRecognizer(detailTap)
        
        updateUI()
    }
    
    override func bind() {
//        detailTap.rx.event.bind { [weak self] _ in
//            self?.jumpNextAction()
//        }.disposed(by: disposeBag)
        
        textLabel.rx.tapGesture().when(.recognized).subscribe(onNext:{ [weak self] _ in
            guard let self = self else {return}
            NormalPopupView.show(text: "广告2", navigation: self.navigation, groupId: PopupGroupId.home, popupId: PopupId.advert)
        }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        textLabel.text = text
    }
    
    private func jumpNextAction() {
        navigation?.pushViewController(ImageViewController(), completion: nil)
        // 跳转详情暂停下一页跳转
        schedulerModel.nextShowType = .pause
        dissmissAction()
    }
    
    @objc func dissmissAction() {
        tapDissmiss()
    }
}
