//
//  NotificationAction.swift
//  WaterReminder
//
//  Created by YYang on 21/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import UserNotifications
import Universal

/// 通知 action  后续扩展直接添加
///
/// - delayAction: 延迟 action
/// - doneAction:  完成 action
public enum RemindCategoryAction : String {
    case delayAction
    case doneAction
}


/// 通知 actionCategory 后续扩展直接添加
///
/// - localRemind: 本地提醒
public enum RemindCategoryType : String {
    case localRemind
}


class NotificationAction : NSObject {
    
    // MARK: - 注册通知 actionCategory
    public func registerNotificationCategory() {
        //本地通知  喝水提醒 喝一杯 / 拖延一杯
        let localRemindCotegory  = UNNotificationCategory(identifier: RemindCategoryType.localRemind.rawValue, actions: [doneAction,delayAction], intentIdentifiers: [], options: [.customDismissAction])
        
        //更多action 注册同上.....
        
        //注册 action 簇
        UNUserNotificationCenter.current().setNotificationCategories([localRemindCotegory])
        
    }
    
    // MARK: -  action 处理事件
    public func categoryHandler(response: UNNotificationResponse) {
        if let categoryIdentifier = RemindCategoryType(rawValue: response.notification.request.content.categoryIdentifier) {
            switch categoryIdentifier {
            case .localRemind: //本地喝水提醒
                localRemindHandler(response: response)
            }
        }
        
    }
    
    private func localRemindHandler(response: UNNotificationResponse) {
        if let actionIdentifer = RemindCategoryAction(rawValue: response.actionIdentifier) {
            switch actionIdentifer {
            case .delayAction:
                delayOperation(response: response)
            case .doneAction:
                doneOperation(response: response)
            }
        }
    }
    
    // MARK: - action 点击事件
    /// 点击延后
    ///
    /// - Parameter response: response description
    private func delayOperation(response: UNNotificationResponse) {
        print(response.actionIdentifier)
        //获取到当前通知的内容
        let request = response.notification.request
        //创建一个提醒的实体类
        var alarmInfo = AlarmInfo()
        alarmInfo.time = "5"
        alarmInfo.isRepeat = false
        alarmInfo.on = true
        alarmInfo.contentTitle = request.content.title
        alarmInfo.contentSubtitle = request.content.subtitle
        alarmInfo.contentBody = "你ཀ拖ཀ延ཀ的ཀ5分ཀ钟ཀ ~~ 外ཀ星ཀ人ཀ都ཀ快ཀ占ཀ领ཀ地ཀ球ཀ了ཀ ~~ 快ཀ喝ཀ水ཀ!!!!!"
        alarmInfo.contentBadge = request.content.badge!
        alarmInfo.timeType = .Calendar
        // 添加一条新的一次性通知
        alarmModel.sendDisposableNotification(alarmInfoEntity: nil, alarmInfo: alarmInfo, identifier: nil) { (error) in
        }
        
    }
    
    /// 点击立马喝一杯点击事件
    ///
    /// - Parameter response: response description
    private func doneOperation(response: UNNotificationResponse) {
        print(response.actionIdentifier)
        // FIXME: 水量设置可配置从配置读取
        let _ = CacheUtil.progressCalculatorBy(operation: .Add(200))
    }
    
    
    
    // MARK: - 创建 action
    private lazy var doneAction : UNNotificationAction = {
        let done = UNNotificationAction(identifier: RemindCategoryAction.doneAction.rawValue, title: "立马喝一杯!😄", options: [.destructive])
        return done
    }()
    
    private  lazy var delayAction : UNNotificationAction = {
        let delay = UNNotificationAction(identifier: RemindCategoryAction.delayAction.rawValue, title: "忙不过来 ? 稍后提醒😢", options: [.destructive])
        return delay
    }()
    
    
    lazy var alarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    
    
}
