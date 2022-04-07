//
//  GIFViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2022/4/7.
//

import Foundation
import UIKit
import ProgressHUD

import UIKit
import ImageIO

class GIFViewController: BaseViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func createUI() {
        guard let path = Bundle.main.path(forResource: "load.gif", ofType: nil) else {
                    return
                }
                
                guard let data = NSData(contentsOfFile: path) else {
                    return
                }
                
                guard let imgSource: CGImageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                    return
                }
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
                        gifImageView.image = UIImage(cgImage: cgImage)
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
                
                gifImageView.animationImages = images
                gifImageView.animationDuration = totalDuration
                
                gifImageView.animationRepeatCount = 0
                
                gifImageView.startAnimating()
    }
    
    @IBAction func startTap() {
        ProgressHUD.show("loading")
    }
    
    @IBAction func stopTap() {
        ProgressHUD.showSuccess()
    }
    
    @IBAction func gifTap() {
        ProgressHUD.showError()
    }
    
}
