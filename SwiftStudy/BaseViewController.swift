//
//  BaseViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2021/11/24.
//

import UIKit
import RxSwift
import SnapKit
import SwifterSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        
        createUI()
    }
    
    func createUI() {
    }
}
