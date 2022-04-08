//
//  ShopViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2022/4/8.
//

import Foundation
import UIKit
import TJShopSDK

class ShopViewController: BaseViewController {
    
    override func createUI() {
        
    }
    
    
    @IBAction func indexTap() {
        TJShopEngine.default.skipProductList()
    }
    
    @IBAction func listTap() {
        TJShopEngine.default.showProductScence(scenceId: "", config: ScenceConfig(), superView: navigationController?.view ?? self.view)
    }
    
    @IBAction func payTap() {
        
    }
    
}
