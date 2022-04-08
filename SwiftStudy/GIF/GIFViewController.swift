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
        
    }
    
    @IBAction func startTap() {
        TJHUD.showGIFLoading(status: "loading...")
    }
    
    @IBAction func stopTap() {
        TJHUD.dismiss()
    }
    
    @IBAction func gifTap() {
        TJHUD.show(status: "IMG", interaction: false)
    }
    
    @IBAction func textTap() {
        TJHUD.show(status: "你好呀")
    }
    
}
