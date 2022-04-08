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
    public var fontStatus: UIFont = UIFont.systemFont(ofSize: 14)
    public var colorStatus: UIColor = .black
    public var colorSpinner: UIColor = .black
    public var colorHUD: UIColor = .white
    public var colorBackground: UIColor = UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
    public var imagePath: String? = Bundle.main.path(forResource: "load.gif", ofType: nil)
    public var imageSize: CGSize = CGSize(width: 80, height: 80)
    public var maxTextSize: CGSize = CGSize(width: 200, height: 300)
    public var spaceImageText: CGFloat = 8
    public var paddingEdge = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    private var viewBackground: UIView?
    private var viewHUD: UIView?
    private var spinner: UIActivityIndicatorView?
    private var imageView: UIImageView?
    private var labelStatus: UILabel?
    private var timer: Timer?
    
    // MARK: - Display methods
    
    public static func dismiss() {
        DispatchQueue.main.async {
            self.shared.hudHide()
        }
    }
    
    public static func show(status: String?, interaction: Bool = true) {
        DispatchQueue.main.async {
            self.shared.hudCreate(status: status, image: nil, spin: true, hide: true, interaction: interaction)
        }
    }
    
    public static func showLoading() {
        
    }
    
    public static func showGIFLoading(status: String?) {
        if let path = self.shared.imagePath ,FileManager.default.fileExists(atPath: path) {
            DispatchQueue.main.async {
                self.shared.hudCreate(status: status, image: nil, spin: false, hide: false, interaction: true, isGIF: true)
            }
        }
    }
    
    // MARK: - Property methods
    
    public static func fontStatus(font: UIFont) {shared.fontStatus = font}
    public static func colorStatus(color: UIColor) {shared.colorStatus = color}
    public static func colorSpinner(color: UIColor) {shared.colorSpinner = color}
    public static func colorHUD(color: UIColor) {shared.colorHUD = color}
    public static func colorBackground(color: UIColor) {shared.colorBackground = color}
    
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
    
    
    private func hudCreate(status: String?, image: UIImage?, spin: Bool, hide: Bool, interaction: Bool, isGIF: Bool = false) {
        
        if viewHUD == nil {
            viewHUD = UIView(frame: .zero)
            viewHUD?.backgroundColor = colorHUD
            viewHUD?.layer.cornerRadius = 10
            viewHUD?.layer.masksToBounds = true
            self.registerNotifications()
        }
        
        if let window = self.topWindow(),let viewHUD = self.viewHUD  {
            if viewHUD.superview == nil, interaction == false {
                viewBackground = UIView(frame: window.frame)
                if let vb = viewBackground {
                    vb.backgroundColor = colorBackground
                    window.addSubview(vb)
                    vb.addSubview(viewHUD)
                }
            } else {
                window.addSubview(viewHUD)
            }
        }
        
        if spinner == nil {
            var style = UIActivityIndicatorView.Style.large
            if #available(iOS 13, *) { style = .large }
            spinner = UIActivityIndicatorView(style: style)
            spinner?.color = colorSpinner
            spinner?.hidesWhenStopped = true
        }
        
        if spinner?.superview == nil, let spinner = self.spinner {
            viewHUD?.addSubview(spinner)
        }
        
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        if imageView?.superview == nil, let imageView = self.imageView {
            viewHUD?.addSubview(imageView)
        }
        
        if labelStatus == nil {
            labelStatus = UILabel(frame: .zero)
            labelStatus?.font = fontStatus
            labelStatus?.textColor = colorStatus
            labelStatus?.backgroundColor = .clear
            labelStatus?.textAlignment = .center
            labelStatus?.baselineAdjustment = .alignCenters
            labelStatus?.numberOfLines = 0
        }
        if labelStatus?.superview == nil, let labelStatus = self.labelStatus {
            viewHUD?.addSubview(labelStatus)
        }
        
        labelStatus?.text = status
        labelStatus?.isHidden = (status == nil) ? true : false
        
        if isGIF {
            
            self.loadGIFImage(path: imagePath)
        } else {
            imageView?.image = image
            imageView?.isHidden = (image == nil) ? true : false
        }
        
        if spin { spinner?.startAnimating() } else { spinner?.stopAnimating() }
        
        self.hudSize()
        self.hudPosition(nil)
        self.hudShow()
        
        if hide { self.timedHide() }
    }
    
    /// 注册通知
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(hudPosition(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    /// 销毁
    private func hudDestroy() {
        NotificationCenter.default.removeObserver(self)
        labelStatus?.removeFromSuperview()
        labelStatus = nil
        imageView?.stopAnimating()
        imageView?.removeFromSuperview()
        imageView = nil
        spinner?.removeFromSuperview()
        spinner = nil
        viewHUD?.removeFromSuperview()
        viewHUD = nil
        viewBackground?.removeFromSuperview()
        viewBackground = nil
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func hudSize() {
        var labelRect: CGRect = .zero
        var widthHUD = 0.0, heightHUD = 0.0
        
        if let text = labelStatus?.text {
            let attributes = [NSAttributedString.Key.font: labelStatus?.font]
            
            labelRect = text.boundingRect(with: maxTextSize, options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        }
        
        widthHUD = labelRect.width > imageSize.width ? labelRect.width : imageSize.width
        heightHUD = labelRect.height + imageSize.height
        
        // hud布局
        widthHUD += paddingEdge.left + paddingEdge.right
        heightHUD += paddingEdge.top + paddingEdge.bottom + spaceImageText
        viewHUD?.bounds = CGRect(x: 0, y: 0, width: widthHUD, height: heightHUD)
        
        // 图片布局
        imageView?.frame.size = imageSize
        imageView?.frame.origin = CGPoint(x: (widthHUD - imageSize.width)/2, y: paddingEdge.top)
        
        // 文字布局
        labelRect.origin = CGPoint(x: (widthHUD - labelRect.size.width)/2, y: paddingEdge.top + imageSize.height + spaceImageText)
        labelStatus?.frame = labelRect
        
        // 指示器布局
        spinner?.center = imageView?.center ?? CGPoint(x: widthHUD/2, y: heightHUD/2)
    }
    
    @objc private func hudPosition(_ noti: Notification?) {
        
        let screen = UIScreen.main.bounds
        let center = CGPoint(x: screen.width/2, y: screen.height/2)
        
        UIView.animate(withDuration: 0, delay: 0, options: .allowUserInteraction) {
            self.viewHUD?.center = center
        }
        
        if viewBackground != nil {
            viewBackground?.frame = self.topWindow()?.frame ?? .zero
        }
    }
    
    private func loadGIFImage(path: String?) {
        
        guard let path = path else {return}
        
        guard let data = NSData(contentsOfFile: path) else {return}
        
        guard let imgSource: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) else {return}
        // 获取组成gif的图片总数量（gif都是由很多张图片组成）
        let imageCount = CGImageSourceGetCount(imgSource)
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0...imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imgSource, i, nil) else {
                continue
            }
            if i == 0 {
                // gif播放完毕时，展示第一张图
                self.imageView?.image = UIImage(cgImage: cgImage)
            }
            guard let properties : NSDictionary = CGImageSourceCopyPropertiesAtIndex(imgSource, i, nil) else {
                continue
            }
            // 获取单张图片的播放时长
            guard let gifDic = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else {
                continue
            }
            
            guard let duration = gifDic[kCGImagePropertyGIFDelayTime] as? NSNumber else {
                continue
            }
            // 将播放时间累加
            totalDuration += duration.doubleValue
            // 获取到所有的image
            let image = UIImage(cgImage: cgImage)
            images.append(image)
        }
        
        self.imageView?.animationImages = images
        self.imageView?.animationDuration = totalDuration
        self.imageView?.animationRepeatCount = 0
        self.imageView?.startAnimating()
    }

    // MARK: -
    
    private func hudShow() {
        if timer != nil { timer?.invalidate() }
        
        if self.alpha == 0 {
            self.alpha = 1
            viewHUD?.alpha = 0
            viewHUD?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                self.viewHUD?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.viewHUD?.alpha = 1
            }

        }
    }
    
    private func hudHide() {
        if self.alpha == 1 {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
                self.viewHUD?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.viewHUD?.alpha = 0
            } completion: { finished in
                self.hudDestroy()
                self.alpha = 0
            }

        }
    }
    
    private func timedHide() {
        let delay = Double(labelStatus?.text?.count ?? 0) * 0.04 + 0.5
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { timer in
            self.hudHide()
        })
    }

}
