//
//  TJHUD.swift
//  SwiftStudy
//
//  Created by weixin on 2022/4/7.
//

import Foundation
import UIKit

open class TJHUD: UIView {
    
    public static let shared = TJHUD()
    
    // MARK: - property
    public var fontStatus: UIFont = UIFont.boldSystemFont(ofSize: 16)
    public var colorStatus: UIColor = .black
    public var colorSpinner: UIColor = .black
    public var colorHUD: UIColor = .gray
    public var colorBackground: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)

    
    // MARK: - Display methods
    
    public static func dismiss() {
        DispatchQueue.main.async {
            self.shared.hudHide()
        }
    }
    
    public static func show(status: String?, interaction: Bool?) {
        DispatchQueue.main.async {
            self.shared.hudShow()
        }
    }
    
    public static func showLoading() {
        
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    // 获取顶部window
    private func topWindow() -> UIWindow? {
        let windows = UIApplication.shared.windows.reversed()
        for window in windows {
            if window.isKind(of: UIWindow.self)
                && window.windowLevel == .normal // 屏幕级别
                && window.bounds == UIScreen.main.bounds // 屏幕尺寸
                && !window.isHidden && window.alpha != 0 // 是否显示
            {
                return window
            }
        }
        return nil
    }
    
    
    func hudCreate(status: String, image: UIImage, spin: Bool, hide: Bool, Interaction: Bool) {
        
    }
    
    // MARK: -
    
    func hudShow() {
        
    }
    
    func hudHide() {
        
    }
    
    func timedHide() {
        
    }

}
