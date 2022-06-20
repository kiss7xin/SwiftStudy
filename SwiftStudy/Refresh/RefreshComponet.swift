//
//  RefreshComponet.swift
//  SwiftStudy
//
//  Created by weixin on 2022/4/11.
//

import Foundation
import MJRefresh
import UIKit

class RefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        
        let path = Bundle(for: RefreshHeader.self).resourcePath! + "/TJShopSDK.bundle"
        if let shopBundle = Bundle(path: path),
           let gifPath = shopBundle.path(forAuxiliaryExecutable: "load.gif"),
           let imageInfo = RefreshComponet.gifImages(path: gifPath)
        {
            self.setImages(imageInfo.0, duration: imageInfo.1, for: .idle)
            self.setImages(imageInfo.0, duration: imageInfo.1, for: .pulling)
            self.setImages(imageInfo.0, duration: imageInfo.1, for: .refreshing)
        }

        // 隐藏时间 状态
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
    }
}

//class RefreshFooter: MJRefreshAutoGifFooter {
//
//    override func prepare() {
//        super.prepare()
//
//        let path = Bundle(for: RefreshHeader.self).resourcePath! + "/TJShopSDK.bundle"
//        if let shopBundle = Bundle(path: path),
//           let gifPath = shopBundle.path(forAuxiliaryExecutable: "load.gif"),
//           let imageInfo = RefreshComponet.gifImages(path: gifPath)
//        {
//            self.setImages(imageInfo.0, duration: imageInfo.1, for: .refreshing)
//        }
//    }
//}

class RefreshFooter: MJRefreshAutoFooter {
    
    var loading:UIActivityIndicatorView!
    
    override func prepare() {
        super.prepare()
        
        // 设置控件的高度
        self.mj_h = 50
        
        self.loading =  UIActivityIndicatorView(style: .medium)
        self.addSubview(self.loading)
    }
    
    override func placeSubviews()
    {
        super.placeSubviews()
        self.loading.center = CGPoint(x:self.mj_w * 0.5, y:self.mj_h * 0.5)
    }

    //监听控件的刷新状态
    override var state: MJRefreshState{
        didSet
        {
            switch (state) {
            case .idle:
                self.loading.stopAnimating()
                break
            case .refreshing:
                self.loading.startAnimating()
                break
            case .noMoreData:
                self.loading.stopAnimating()
                break
            default:
                break
            }
        }
    }

    //监听scrollView的contentOffset改变
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }

    //监听scrollView的contentSize改变
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }

    //监听scrollView的拖拽状态改变
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
}

class RefreshComponet {
    
    static func gifImages(path: String?) -> ([UIImage], TimeInterval)? {
        
        guard let path = path else {return nil}
        
        guard let data = NSData(contentsOfFile: path) else {return nil}
        
        guard let imgSource: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) else {return nil}
        // 获取组成gif的图片总数量（gif都是由很多张图片组成）
        let imageCount = CGImageSourceGetCount(imgSource)
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0...imageCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imgSource, i, nil) else {
                continue
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
        return (images, totalDuration)
    }
}
