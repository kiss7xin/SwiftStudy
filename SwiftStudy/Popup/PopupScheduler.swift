//
//  Popupdialog.swift
//  EnterpriseUniversity
//
//  Created by weixin on 2021/9/18.
//

import Foundation

public struct PopupGroupId {
    /// 其他
    public static let other = "other"
    /// 首页
    public static let home = "home"
    /// 学海
    public static let ocean = "ocean"
    /// 公共组
    public static let common = "commonGroup"
}

/// 根据弹窗id进行排序显示
public struct PopupId {
    /// 版本更新
    public static let update_version: Int = 1
    /// 过期
    public static let expiration : Int = 5
    /// 大学提示
    public static let university_tip : Int = 10
    /// 感兴趣标签
    public static let interest_label: Int = 15
    /// 考试交卷
    public static let exam_check: Int = 20
    /// 内训口令
    public static let live_train: Int = 25
    /// 广告
    public static let advert: Int = 30
}

enum PopupNextShowType {
    case normal // 正常
    case pause  // 暂停
    case interupt // 截断
    case clean // 清空
}

final class PopupDialogModel {
    /// 分组id
    var groupId: String = ""
    /// 弹窗id
    var popupId: Int = 0
    ///弹窗状态
    var nextShowType: PopupNextShowType = .normal
    /// 弹窗是否在展示
    var configIsShow: Bool = false
}

protocol PopupDialogConfig {
    /// 弹窗组id
    func popupGroupId() -> String
    /// 获取弹窗id
    func getPopupId() -> Int
    /// 是否截断下一个显示 0：不处理，1：暂停，即之后可恢复显示，2：截断，即清除后面的显示
    func popupConfigNextShowHandle() -> PopupNextShowType
    /// 弹窗是否在显示
    func popupConfigIsShow() -> Bool
    /// 触发显示
    func popupConfigTriggerShow(_ show: Bool) -> Void
}

class PopupManager: NSObject {
    
    public static let shared = PopupManager()
    
    var mTaskOrders = [String]()
    var mTasks = [PopupDialogConfig]()
    var commonGroup = PopupGroupId.common // 当前组
    var currentDifGroup = "-1"    //当前非公共组
    
    public func addWhenJoin(groupId: String = PopupGroupId.common, popupId: Int) {
        if popupId == 0 { return }
        mTaskOrders.append(orderKey(groupId, popupId))
        mTaskOrders.sort(by: {orderDialog(orderKey: $0) < orderDialog(orderKey: $1) })
    }
    
    private func orderKey(_ groupId: String, _ popupId: Int) -> String {
        return "\(groupId)-\(popupId)"
    }
    
    private func orderKey(dialog: PopupDialogConfig) -> String {
        return "\(dialog.popupGroupId())-\(dialog.getPopupId())"
    }
    
    private func orderGroup(orderKey: String) -> String {
        return orderKey.components(separatedBy: "-").first ?? ""
    }
    
    private func orderDialog(orderKey: String) -> String {
        return orderKey.components(separatedBy: "-").last ?? ""
    }
    
    /// 显示时填加弹窗
    /// - Parameter dialog: 弹窗
    public func addWhenShow(dialog: PopupDialogConfig) {
        if dialog.popupGroupId() != commonGroup {
            currentDifGroup = dialog.popupGroupId()
        }
        
        let dialogConfig = mTasks.filter {
            orderKey(dialog: $0) == orderKey(dialog: dialog)
        }.first
        
        if let it = dialogConfig {
            mTasks.removeAll {
                orderKey(dialog: $0) == orderKey(dialog: it)
            }
        }
        mTasks.append(dialog)
        mTasks.sort(by: {$0.getPopupId() < $1.getPopupId() })
        
        // 如果队列内已有该弹窗并正在展示，关闭已有弹窗并弹出新弹窗
        if let it = dialogConfig {
            if it.popupConfigIsShow() {
                it.popupConfigTriggerShow(false)
                dialog.popupConfigTriggerShow(true)
                return
            }
        }
        
        let thisGroupDialog = mTasks.first { filterGroup($0.popupGroupId(), dialog.popupGroupId()) }
        let diglogOrder = mTaskOrders.filter { $0 == orderKey(dialog: dialog) }
        if diglogOrder.isEmpty, !mTaskOrders.isEmpty {
            let index = (mTaskOrders.lastIndex { (orderDialog(orderKey: $0)).int! < dialog.getPopupId() } ?? -1) + 1
            mTaskOrders.insert(orderKey(dialog: dialog), at: index)
            if let it = thisGroupDialog {
                if index == 0 && it.popupConfigIsShow() {
                    it.popupConfigTriggerShow(false)
                    dialog.popupConfigTriggerShow(true)
                    return
                }
            }
        }
        
        openCurrentGroupDialog(groupId: dialog.popupGroupId())
    }
    
    public func cleanDialogs() {
        mTaskOrders.removeAll()
        mTasks.removeAll()
    }
    
    /// 移除不需要显示的弹窗
    public func removeWhenUserless(groupId: String, popupId: Int) {
        mTaskOrders.removeAll { $0 == orderKey(groupId, popupId) }
        mTasks.removeAll { orderKey(dialog: $0) == orderKey(groupId, popupId) }
        openDialog(groupId: groupId)
    }
    
    private func removeWhenDismiss(dialog: PopupDialogConfig) {
        if mTasks.isEmpty { return }
        mTasks.removeAll{ orderKey(dialog: dialog) == orderKey(dialog: $0) }
        mTaskOrders.removeAll { $0 == orderKey(dialog: dialog) }
    }
    
    /// 消失时移除
    /// - Parameter dialog: 弹窗调度配置
    public func removeWhenDismissAndShowNext(dialog: PopupDialogConfig) {
        removeWhenDismiss(dialog: dialog)
        switch dialog.popupConfigNextShowHandle() {
        case .normal:
            openDialog(groupId: dialog.popupGroupId())
        case .interupt:
            mTaskOrders.removeAll { filterGroup( orderGroup(orderKey: $0), dialog.popupGroupId()) }
            mTasks.removeAll{ filterGroup($0.popupGroupId(),dialog.popupGroupId())}
        case .pause:
            break
        case .clean:
            cleanDialogs()
        }
    }
    
    /// 开启当前组的弹窗
    /// - Parameter groupId: 组id
    func openCurrentGroupDialog(groupId: String) {
        if groupId != commonGroup {
            currentDifGroup = groupId
        }
        if mTasks.filter({ filterGroup($0.popupGroupId(), groupId) }).any(matching: { $0.popupConfigIsShow()}) {
           return
        }
        openDialog(groupId: groupId)
    }
    
    private func openDialog(groupId: String) {
        let dialog = mTasks.first{ filterGroup($0.popupGroupId(), groupId) }
        guard let it = dialog else { return }
        if mTaskOrders.isEmpty, !it.popupConfigIsShow() {
            it.popupConfigTriggerShow(true)
            return
        }
        if orderKey(dialog: it) == mTaskOrders.first, !it.popupConfigIsShow() {
            it.popupConfigTriggerShow(true)
        }
    }
    
    /// 组id相等判断
    private func filterGroup(_ thisGroupId: String,_ othergroupId: String) -> Bool {
        return thisGroupId == commonGroup || thisGroupId == othergroupId || thisGroupId == currentDifGroup
    }
    
}


