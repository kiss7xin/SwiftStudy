//
//  ViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2021/8/28.
//

import UIKit
import RxSwift
import RxCocoa

enum VCType {
    case code
    case xib
    case storyboard
}

struct DataModel {
    let className: UIViewController.Type?
    let name: String?
    var type: VCType = .code
}

struct DataListModel {
    let data = Observable.just([
        DataModel(className: GradientLayerController.self,name: "渐变色-GradientLayer"),
        DataModel(className: ImageViewController.self,name: "图片-UIImage"),
        DataModel(className: PopoverController.self, name: "弹出"),
        DataModel(className: PopTabbarVC.self, name: "弹窗管理类", type: .storyboard),
        DataModel(className: WebViewController.self, name: "网页", type: .storyboard),
        DataModel(className: TabCardVC.self, name: "卡片视图"),
        DataModel(className: GIFViewController.self, name: "GIF", type: .storyboard),
        DataModel(className: ShopViewController.self, name: "uniapp", type: .storyboard),
        DataModel(className: RefreshViewController.self, name: "刷新加载"),
        ])
}

class ViewController: BaseViewController {

    @IBOutlet weak var myTable: UITableView!
    
    let dataList = DataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data
            .bind(to: myTable.rx.items(cellIdentifier: "myCell")) { _, model, cell in
                cell.textLabel?.text = model.name
            }.disposed(by: disposeBag)
        
        myTable.rx.modelSelected(DataModel.self).subscribe { event in
            let lVCClass = event.element?.className
            if let lVCClass = lVCClass {
                switch event.element?.type {
                case .code:
                    let lVC = lVCClass.init()
                    self.navigationController?.pushViewController(lVC, animated: true)
                case .xib:
                    let lVC = lVCClass.init()
                    self.navigationController?.pushViewController(lVC, animated: true)
                case .storyboard:
//                    // 1.动态获取命名空间
//                    guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]as? String else{
//                        return
//                    }
//                    guard let className = NSClassFromString(nameSpace + "." + "ViewController")as? UIViewController.Type else{
//                        return
//                    }
                    let className = NSStringFromClass(lVCClass.self)
                    guard let name = className.components(separatedBy: ".").last else {
                        return
                    }
                    let lVC = self.storyboard?.instantiateViewController(withIdentifier: name)
                    if let vc = lVC {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case .none:
                    break
                }
            }
        }.disposed(by: disposeBag)
    }
}

