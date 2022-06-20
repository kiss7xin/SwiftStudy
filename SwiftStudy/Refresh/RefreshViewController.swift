//
//  RefreshViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2022/4/11.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift

class RefreshViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items:[String]!
    var tableView: UITableView?
    
    // 顶部刷新
    let header = RefreshHeader()
    let footer = RefreshFooter()
        
    override func createUI() {
        //随机生成一些初始化数据
        refreshItemData()
       
        //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                               forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)

        //下拉刷新相关设置
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.tableView!.mj_header = header
        
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.isAutomaticallyRefresh = false
        self.tableView!.mj_footer = footer
    }
    
    //初始化数据
    func refreshItemData() {
        items = []
        for _ in 0...20 {
          items.append("条目\(Int(arc4random()%100))")
        }
    }

    //顶部下拉刷新
    @objc func headerRefresh(){
        print("下拉刷新.")
        sleep(1)
        //重现生成数据
        refreshItemData()
        //重现加载表格数据
        self.tableView!.reloadData()
        //结束刷新
        self.tableView!.mj_header?.endRefreshing()
    }
        
    //上拉加载
    @objc func footerRefresh() {
        print("上拉加载.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //生成数据
            self.loadMoreData()
            //重现加载表格数据
            self.tableView!.reloadData()
            //结束刷新
            self.tableView!.mj_footer?.endRefreshing()
        }
    }
        
    func loadMoreData() {
        for _ in 0...9 {
            items.append("条目\(Int(arc4random()%100))")
        }
    }

    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
      -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "SwiftCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                               for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
