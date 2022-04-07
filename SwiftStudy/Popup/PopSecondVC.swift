//
//  PopSecondVC.swift
//  SwiftStudy
//
//  Created by weixin on 2021/12/10.
//

import UIKit

class PopSecondVC: BaseViewController {
    
    let groupId = PopupGroupId.ocean
    
    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("按钮1", for: .normal)
        button.addTarget(self, action: #selector(click1), for: .touchUpInside)
        return button
    }()
    
    lazy var popButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("按钮2", for: .normal)
        button.addTarget(self, action: #selector(click2), for: .touchUpInside)
        return button
    }()
    
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
        
        PopupManager.shared.addWhenJoin(groupId: groupId, popupId: PopupId.update_version)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            NormalPopupView.show(text: "版本更新", navigation: self.navigationController, groupId: self.groupId, popupId: PopupId.update_version)
//            PopupManager.shared.removeWhenUserless(groupId: self.groupId, popupId: PopupId.update_version)
        }
        
        PopupManager.shared.addWhenJoin(groupId: groupId, popupId: PopupId.exam_check)
        NormalPopupView.show(text: "课程上报", navigation: self.navigationController, groupId: groupId, popupId:  PopupId.exam_check)
        
        PopupManager.shared.addWhenJoin(groupId: groupId, popupId: PopupId.interest_label)
        NormalPopupView.show(text: "推荐", navigation: navigationController, groupId: groupId, popupId: PopupId.interest_label)
        
        PopupManager.shared.addWhenJoin(groupId: groupId, popupId: PopupId.live_train)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            NormalPopupView.show(text: "内训", navigation: self.navigationController, groupId: self.groupId, popupId: PopupId.live_train)
        }
        
        PopupManager.shared.addWhenJoin(groupId: groupId, popupId: PopupId.advert)
        NormalPopupView.show(text: "广告", navigation: navigationController, groupId: groupId, popupId: PopupId.advert)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func click1() {
        NormalPopupView.show(text: "广告3", navigation: navigationController, groupId: groupId, popupId: PopupId.advert)
    }
    
    @objc func click2() {
        NormalPopupView.show(text: "广告4", navigation: navigationController, groupId: groupId, popupId: PopupId.advert)
    }
}
