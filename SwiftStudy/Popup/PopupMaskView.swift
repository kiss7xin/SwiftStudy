//
//  PopupMaskView.swift
//  EnterpriseUniversity
//
//  Created by weixin on 2021/9/24.
//

import UIKit

class PopupMaskView: UIView, PopupDialogConfig {
    
    var schedulerModel = PopupDialogModel()
    enum Position {
        /// 居中
        case center
        /// 底部
        case bottom
    }
    /// 背景
    private lazy var mMaskView = UIView()
    /// 位置
    private var position: Position = .bottom
    /// 背景颜色， 默认黑色
    var maskBackgourndColor: UIColor? = UIColor(hex: 0x000000, transparency: 0.6) {
        didSet {
            mMaskView.backgroundColor = maskBackgourndColor
        }
    }
    /// 动画时间
    private var duration: TimeInterval = 0.3
    /// 背景点击关闭
    var maskTapClose: Bool = true {
        didSet {
            if maskTapClose {
                addMaskTap()
            } else {
                removeMaskTap()
            }
        }
    }
    /// 显示的view
    var contentView = UIView()
    
    init(position: Position, duration: TimeInterval? = nil) {
        self.position = position
        if let d = duration {
            self.duration = d
        } else {
            switch position {
            case .bottom:
                self.duration = 0.2
            case .center:
                self.duration = 0.3
            }
        }
        super.init(frame: .zero)
        create()
        createUI()
        self.layoutIfNeeded()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 公开方法
    func showView(popupModel: PopupDialogModel) {
        self.schedulerModel = popupModel
        PopupManager.shared.addWhenShow(dialog: self)
    }
    
    func replaceShowView() {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        switch position {
        case .bottom:
            self.mMaskView.alpha = 0.0
            contentView.snp.remakeConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(-contentView.bounds.height)
                make.left.right.equalToSuperview()
                make.height.greaterThanOrEqualTo(44)
            }
            UIView.animate(withDuration: duration) {
                self.mMaskView.alpha = 1.0
                self.layoutIfNeeded()
            }
        case .center:
            self.alpha = 0.0
            UIView.animate(withDuration: duration) {
                self.alpha = 1.0
            }
        }
    }
    
    @objc func tapDissmiss() {
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            PopupManager.shared.removeWhenDismissAndShowNext(dialog: self)
        }
    }
    /// 关闭view
    func dismiss() {
        switch position {
        case .bottom:
            contentView.snp.updateConstraints { make in
                make.top.equalTo(self.snp.bottom)
            }
            UIView.animate(withDuration: duration) {
                self.mMaskView.alpha = 0.0
                self.layoutIfNeeded()
            } completion: { _ in
                self.removeFromSuperview()
            }
        case .center:
            UIView.animate(withDuration: duration) {
                self.alpha = 0.0
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    func createUI() {
        
    }
    
    func bind() {
        
    }
    //MARK: - private
    private func addMaskTap() {
        mMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDissmiss)))
    }
    private func removeMaskTap() {
        mMaskView.removeGestureRecognizers()
    }
    private func create() {
        addMaskTap()
        mMaskView.backgroundColor = maskBackgourndColor
        contentView.backgroundColor = .white
        addSubview(mMaskView)
        mMaskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(contentView)
        switch position {
        case .bottom:
            contentView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.snp.bottom)
                make.height.greaterThanOrEqualTo(44)
            }
        case .center:
            contentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.greaterThanOrEqualTo(300)
                make.width.greaterThanOrEqualTo(300)
            }
        }
    }
    
    func popupGroupId() -> String {
        return schedulerModel.groupId
    }
    
    func getPopupId() -> Int {
        return schedulerModel.popupId
    }
    
    func popupConfigNextShowHandle() -> PopupNextShowType {
        return schedulerModel.nextShowType
    }
    
    func popupConfigIsShow() -> Bool {
        return schedulerModel.configIsShow
    }
    
    func popupConfigTriggerShow(_ show: Bool) {
        if show {
            if !schedulerModel.configIsShow {
                schedulerModel.configIsShow = true
                replaceShowView()
            }
        } else {
            dismiss()
        }
    }
}
