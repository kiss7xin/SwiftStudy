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

    override func createUI() {
        
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
