//
//  GradientLayerController.swift
//  SwiftStudy
//
//  Created by weixin on 2021/11/24.
//

import UIKit
import RxSwift

class GradientLayerController: BaseViewController {
    override func createUI() {
        var list = [1,2,3,4]
        list.removeAll()
        print(list)
        list.append(3)
        print(list)
    }
}
