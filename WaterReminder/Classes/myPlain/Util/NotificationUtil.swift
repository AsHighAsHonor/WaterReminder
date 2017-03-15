//
//  NotificationUtil.swift
//  WaterReminder
//
//  Created by YYang on 02/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import UserNotifications
import Universal




class NotificationUtil: NSObject ,UNUserNotificationCenterDelegate{
    
    let actObj = NotificationAction()  //初始化action对象
    
    
    /// 注册通知的 action 簇
    public func registerNotiCategory() {
        actObj.registerNotificationCategory()
    }
    
    
    /// 向用户申请通知授权
    ///
    public class func requestNotificationAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                print("Request Notification Authorization Success")
            } else {
                if let error = error {
                    UIAlertController.showConfirmAlertFromTopViewController(message :error.localizedDescription)
                }
            }
        }
        
    }
    
    
    ///必须实现UNUserNotificationCenter的代理方法  前台收到通知后才能展示
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        let tigger = notification.request.trigger
        if (tigger != nil)  && tigger.self === UNPushNotificationTrigger.self {
            //应用处于前台时的远程推送接受
            //关闭友盟自带的弹出框
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(info)
            UMessage.setAutoAlert(false)
            
        }else{
            //应用处于前台时的本地推送接受
        }
        
        //当应用处于前台时提示设置
        completionHandler([.alert, .sound,.badge])
    }
    
    ///用户点击通知时调用的方法, 在该方法里，我们将获取到这个推送请求对应的 response，UNNotificationResponse 是一个几乎包括了通知的所有信息的对象，从中我们可以再次获取到 userInfo 中的信息 , 远程推送的 payload 内的内容也会出现在这个 userInfo 中，这样一来，不论是本地推送还是远程推送，处理的路径得到了统一。通过 userInfo 的内容来决定页面跳转或者是进行其他操作，都会有很大空间。和普通的通知并无二致，actionable 通知也会走到 didReceive 的 delegate 方法，我们通过 request 中包含的 categoryIdentifier 和 response 里的 actionIdentifier 就可以轻易判定是哪个通知的哪个操作被执行了。对于 UNTextInputNotificationAction 触发的 response，直接将它转换为一个 UNTextInputNotificationResponse，就可以拿到其中的用户输入
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //actionable  点击 action 后的操作 根据 category Identifier 判断
        actObj.categoryHandler(response: response)
        
        
        print("UNUserNotificationResponseInfo: \(response.notification.request.content.userInfo)")
        
        let info = response.notification.request.content.userInfo
        let tigger = response.notification.request.trigger
        if (tigger != nil)  && tigger.self === UNPushNotificationTrigger.self {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(info)
        }else{
            //应用处于后台时的本地推送接受
        }
        completionHandler()
    }
    
    
    // MARK: - 每日水量重置
    public func dailyCheck() -> () {
        let savedMark = UserDefaults(suiteName: "group.com.ZTESoft.app")!.object(forKey: UserSetting.DailyMark.rawValue) as? String
        let currentStr = dailyMark()
        
        if let savedMark = savedMark {
            YYPrint("保存的时间:\(savedMark) , 当前时间 :\(currentStr)")
            if savedMark != currentStr {
                CacheUtil.deleteWater(type: .DrinkingWater(0))
                CacheUtil.deleteWater(type: .TargetWater(0))
            }
        }
        
    }
    
    private func dailyMark() -> String {
        let date  = Date()
        let formatter =   DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateStr = formatter.string(from: date)
        print("dailyMark--------->>\(dateStr)")
        return dateStr
    }
    
    
    
    
}
