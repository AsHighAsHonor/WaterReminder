//
//  WaterAlarmModel.swift
//  WaterReminder
//
//  Created by YYang on 02/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import MapKit

///执行跳转的 segueIdentity
public enum SegueId : String {
    case AddCalendarSegue = "AddCalendarSegue"
    case AddLocationSegue = "AddLocationSegue"
    case AddMapSegue = "AddMapSegue"
    case AddContentSegue = "AddContentSegue"
    case AddCalendarContentSegue = "AddCalendarContentSegue"
}


/// 提醒类型
///
/// - Interval: 时间间隔
/// - Location: 地理位置
/// - Calendar: 日期
public enum AlarmType : String{
    case Interval = "倒计时"
    case Location = "地理位置"
    case Calendar = "时间"
}


public class AlarmInfo {
    var time : String?
    var isRepeat : Bool?
    var on : Bool?
    var sound : String?
    var contentTitle : String?
    var contentSubtitle : String?
    var contentBody : String?
    var contentBadge : NSNumber?
    var timeType : AlarmType?
    var showTitle : String?
    var onEnter : Bool?
    var onExit : Bool?
    var radius : NSNumber?
    
}



class WaterAlarmModel: NSObject {
    
    // MARK: - Notification Operation
    
    
    /// 获取当前等待触发的通知
    func getPendingNotificationRequest() -> () {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            YYPrint("已经添加的通知 ====>>>\n \($0.count)===>>>> \n\($0.description)")
        }
    }
    
    
    /// 添加一条新的通知/修改一条通知
    ///
    /// - Parameters:
    ///   - alarmInfo: 新通知内容实体
    ///   - identifier: 要修改的identifier 可选 添加操作时传 nil
    ///   - alarmInfoEntity: 修改操作时需要传入的数据实体 可选 添加操作时为 nil
    ///   - withCompletionHandler: 回调
    public func sendNotification(alarmInfoEntity : AlarmInfosEntiy? , alarmInfo : AlarmInfo , identifier : String? , withCompletionHandler : ((Error?) -> Void)?){
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = alarmInfo.contentTitle!
        content.body = alarmInfo.contentBody!
        content.badge = alarmInfo.contentBadge!
        content.subtitle = alarmInfo.contentSubtitle!
        content.userInfo = ["key": "value"]
        
        if alarmInfo.sound != nil && alarmInfo.sound != ""{
            content.sound = UNNotificationSound(named: alarmInfo.sound!)
        }else{
            content.sound = UNNotificationSound(named: "sub.caf")
        }
        
        //三种notify    Calendar  location Interval
        var trigger : UNNotificationTrigger
        switch alarmInfo.timeType! {
        case .Calendar:
            content.categoryIdentifier = RemindCategoryType.localRemind.rawValue //设置通知 action 簇
            //设置提醒触发的trigger
            let times = alarmInfo.time!.components(separatedBy: ":")
            var date = DateComponents()
            date.hour = Int(times.first!)
            date.minute = Int(times.last!)
            // Create a trigger to decide when/where to present the notification
            trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: alarmInfo.isRepeat!)
            
        case .Location:
            let locations = alarmInfo.time!.components(separatedBy: "+")//从alarmInfo.time是由"latitude + longitude "拼接的字符串
            let latitude = Double(locations.first!)
            let longitude = Double (locations.last!)
            let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let region = CLCircularRegion(center: center, radius: (alarmInfo.radius?.doubleValue)!, identifier: identifier!)
            region.notifyOnEntry = alarmInfo.onEnter!
            region.notifyOnExit = alarmInfo.onExit!
            trigger = UNLocationNotificationTrigger(region: region, repeats: alarmInfo.isRepeat!)
            
            
        case .Interval://待用
            // Create a trigger to decide when/where to present the notification
            guard let multiple = Double(alarmInfo.time!) else {
                assert((Double(alarmInfo.time!) == nil), "check alarmInfo.time that must be covert to double")
                return
            }
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: multiple*60, repeats: alarmInfo.isRepeat!)
        }
        
        
        
        // Create an identifier for this notification. So you could manage it later. 每条通知的标识符
        var requestIdentifier : String?
        if identifier != nil{
            requestIdentifier = identifier!
        }else{
            requestIdentifier = UUID().uuidString
        }
        
        
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: withCompletionHandler)
        
        //将新通知存储到 CoreData
        if (identifier != nil) && (alarmInfoEntity != nil){
            //修改数据库对应提醒数据
            updateAlarmFromDatabase(entity: alarmInfoEntity!, alarmInfo: alarmInfo)
        }else{
            //新增提醒信息到数据库
            storeAlarmInfosToDatabase(alarmInfo: alarmInfo, andIdentifier: requestIdentifier!)
        }
    }
    
    
    /// 添加一条一次性通知在设定时间后触发,临时提醒 ;不保存到数据库
    ///
    /// - Parameters:
    /// - Parameters:
    ///   - alarmInfo: 新通知内容实体 (alarmInfo.time 传入触发时间间隔 如5 代表5 * 60= 300s 后触发)
    ///   - identifier: 要修改的identifier(备用  统一传 nil)
    ///   - alarmInfoEntity: 修改操作时需要传入的数据实体 (备用 统一传 nil)
    ///   - withCompletionHandler: 回调
    public func sendDisposableNotification(alarmInfoEntity : AlarmInfosEntiy? , alarmInfo : AlarmInfo , identifier : String? , withCompletionHandler : ((Error?) -> Void)?){
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = alarmInfo.contentTitle!
        content.body = alarmInfo.contentBody!
        content.badge = alarmInfo.contentBadge
        content.subtitle = alarmInfo.contentSubtitle!
        if alarmInfo.sound != nil && alarmInfo.sound != ""{
            content.sound = UNNotificationSound(named: alarmInfo.sound!)
        }else{
            content.sound = UNNotificationSound(named: "sub.caf")
        }
        content.userInfo = ["key": "value"]
        
        //地理触发器 不需要 actionCategory
        if alarmInfo.timeType != .Location {
            content.categoryIdentifier = RemindCategoryType.localRemind.rawValue //设置通知 action 簇
        }
        
        // Create an identifier for this notification. So you could manage it later. 每条通知的标识符
        var requestIdentifier : String?
        if identifier != nil{
            requestIdentifier = identifier!
        }else{
            requestIdentifier = UUID().uuidString
        }
        
        //设置提醒触发的trigger
        // Create a trigger to decide when/where to present the notification
        guard let multiple = Double(alarmInfo.time!) else {
            assert((Double(alarmInfo.time!) == nil), "check alarmInfo.time that must be covert to double")
            return
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (multiple*60.0), repeats: alarmInfo.isRepeat!)//设置提醒间隔
        // The request describes this notification.
        let request = UNNotificationRequest(identifier: requestIdentifier!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: withCompletionHandler)
        
    }
    
    
    
    
    /// 恢复禁用的提醒 (已经从通知中移除 但是数据库中存在的)
    ///
    /// - Parameter alarmInfoEntitys: 数据库中信息实体
    private func restoreNotifications(alarmInfoEntitys: [AlarmInfosEntiy]) -> () {
        for entity in alarmInfoEntitys {
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = entity.title!
            content.body = entity.body!
            content.badge = entity.badge as NSNumber?
            content.subtitle = entity.subtitle!
            if entity.sound != nil && entity.sound != ""{
                content.sound = UNNotificationSound(named: entity.sound!)
            }else{
                content.sound = UNNotificationSound(named: "sub.caf")
            }
            content.userInfo = ["key": "value"]
            
            
            let times = entity.time!.components(separatedBy: ":")
            var date = DateComponents()
            date.hour = Int(times.first!)
            date.minute = Int(times.last!)
            
            // Create a trigger to decide when/where to present the notification
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: entity.isRepeat)
            
            // Create an identifier for this notification. So you could manage it later.
            let requestIdentifier = entity.identifier!
            // The request describes this notification.
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print(" restore notification fail : \(error.localizedDescription)")
                } else {
                    print("Notification request restored: \(entity.identifier!) ")
                }
                
            })
        }
    }
    
    
    
    
    /// 移除指定通知 / 移除所有通知
    ///
    /// - Parameters:
    ///   - alarmInfoEntitys: 指定移除的通知实体 , 传入 nil 表示移除所有通知
    ///   - fromDatabase: 是否从数据库删除对应的记录   false 不删除 / true  删除
    public func removeNotification(alarmInfoEntitys : [AlarmInfosEntiy]? , fromDatabase : Bool) {
        
        //先保存要删除的消息identifier
        var identifirs = [String]()
        if  let alarmInfoEntitys = alarmInfoEntitys  {
            for entity in alarmInfoEntitys {
                identifirs.append(entity.identifier!)
            }
        }
        //移除数据库记录
        if fromDatabase {
            self.deleteAlarmInfoFromDatabase(alarmInfoEntitys: alarmInfoEntitys)
        }
        
        let center = UNUserNotificationCenter.current()
        //移除指定通知
        if  !identifirs.isEmpty  {
            
            center.getPendingNotificationRequests { (requestArray :[UNNotificationRequest]) in
                YYPrint("已经添加的通知 ====>>>\n \(requestArray.count)===>>>> \n\(requestArray.description)")
                for item in requestArray {
                    // 根据identifiers移除指定通知
                    let identifier = item.identifier
                    for obj in identifirs{
                        if identifier == obj {
                            //移除通知
                            center.removePendingNotificationRequests(withIdentifiers: [identifier])
                        }
                    }
                }
            }
            
        }else{//移除所有通知
            center.removeAllPendingNotificationRequests()
        }
        
    }
    
    
    
    ///禁用/启用 提醒功能
    ///
    /// - Parameters:
    ///   - toggle: false/true
    ///   - alarmInfoEntitys: alarmInfoEntitys description
    func alarmSwitch( toggle : Bool , alarmInfoEntitys: [AlarmInfosEntiy],completeHandler : (()->())) -> () {
        
        if toggle {
            //1.开启 添加通知
            restoreNotifications(alarmInfoEntitys: alarmInfoEntitys)
        }else{
            //1. 关闭 移除通知
            removeNotification(alarmInfoEntitys: nil, fromDatabase: false)
        }
        
        //2.更新数据库数据 isOn 字段
        if alarmInfoEntitys.count == 1 {
            updateAlarmsFromDatabase(propertiesToUpdate: ["isOn" : toggle], identifier: alarmInfoEntitys.first?.identifier!)
        }else{
            updateAlarmsFromDatabase(propertiesToUpdate: ["isOn" : toggle], identifier: nil)
        }
        
        //3.回调
        completeHandler()
        
    }
    
    
    // MARK: - Core Data Operation
    
    //增
    fileprivate func storeAlarmInfosToDatabase(alarmInfo : AlarmInfo , andIdentifier : String ) {
        
        //2
        let managedObject =  NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext) as!AlarmInfosEntiy
        
        //3
        managedObject.isRepeat = alarmInfo.isRepeat!
        managedObject.identifier = andIdentifier
        managedObject.title = alarmInfo.contentTitle
        managedObject.subtitle = alarmInfo.contentSubtitle
        managedObject.body = alarmInfo.contentBody
        managedObject.badge = Int16(alarmInfo.contentBadge!)
        managedObject.sound = alarmInfo.sound
        managedObject.isOn = alarmInfo.on!
        managedObject.time =  alarmInfo.time
        managedObject.showTitle =  alarmInfo.showTitle!
        managedObject.onExit = alarmInfo.onExit!
        managedObject.onEnter = alarmInfo.onEnter!
        managedObject.radius = Double(alarmInfo.radius!)
        var type = ""
        switch alarmInfo.timeType! {
        case .Calendar:
            type = "时间"
        case .Location:
            type = "地理位置"
        case .Interval:
            type = "倒计时"
        }
        managedObject.timeType = type
        
        //4
        do {
            try managedContext.save()
        } catch let error as NSError  {
            assert(false, error.userInfo.debugDescription)
        }
    }
    
    //查
    public func searchAlarmInfosFromDatabase(identifier : String?) -> ([AlarmInfosEntiy]?) {
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //查询条件不为空按查询条件查询  否则查询全部
        if let _ = identifier {
            //or ,and, not ：或与非
            //fetchRequest.predicate = NSPredicate(format: "stuId = %@ or name = %@", stuId!, name!)
            fetchRequest.predicate = NSPredicate(format : "identifier = %@",identifier!)
        }
        
        //3
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            print("数据库中提醒数量:\(results.count)")
            //强转类型 [AlarmInfosEntiy]
            let infos = results as! [AlarmInfosEntiy]
            return infos
        } catch let error as NSError {
            assert(false, error.userInfo.debugDescription)
            return nil
        }
        
    }
    
    //删除 传入数组可删除多条数据
    fileprivate func deleteAlarmInfoFromDatabase(alarmInfoEntitys : [AlarmInfosEntiy]?) -> () {
        
        //删除指定的数据不为空 删除指定数据否则删除全部
        if let _ = alarmInfoEntitys {
            for alarmInfo in alarmInfoEntitys! {
                managedContext.delete(alarmInfo)
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    assert(false, error.userInfo.debugDescription)
                }
                
            }
        } else{
            //删除所有数据
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try storeCoordinator.execute(deleteRequest, with: managedContext)
                
            } catch let error as NSError {
                assert(false, error.userInfo.debugDescription)
            }
            
        }
        
    }
    
    /// 更新 一条记录多个属性
    fileprivate func updateAlarmFromDatabase(entity : AlarmInfosEntiy ,alarmInfo : AlarmInfo  ) -> () {
        
        //根据 identifier 先查对应的 entity
        let targetEntitys =  searchAlarmInfosFromDatabase(identifier: entity.identifier)
        //修改数据
        for targetEntity in targetEntitys! {
            targetEntity.isRepeat = alarmInfo.isRepeat!
            targetEntity.identifier = entity.identifier
            targetEntity.title = alarmInfo.contentTitle!
            targetEntity.subtitle = alarmInfo.contentSubtitle!
            targetEntity.body = alarmInfo.contentBody!
            targetEntity.badge = Int16(alarmInfo.contentBadge!)
            targetEntity.sound = alarmInfo.sound
            targetEntity.isOn = alarmInfo.on!
            targetEntity.time =  alarmInfo.time!
            targetEntity.showTitle =  alarmInfo.showTitle!
            targetEntity.onExit = alarmInfo.onExit!
            targetEntity.onEnter = alarmInfo.onEnter!
            targetEntity.radius = Double(alarmInfo.radius!)
            var type = ""
            switch alarmInfo.timeType! {
            case .Calendar:
                type = "时间"
            case .Location:
                type = "地理位置"
            case .Interval:
                type = "倒计时"
            }
            targetEntity.timeType = type
            //保存
            do {
                try managedContext.save()
            } catch let error as NSError  {
                assert(false, error.userInfo.debugDescription)
            }
        }
        
    }
    
    
    ///更新 批量更新多个属性
    ///
    /// - Parameters:
    ///   - propertiesToUpdate: 指定更新的属性
    ///   - identifier: 指定需要更新的唯一标示  nil 表示更新数据库内所有数据
    fileprivate  func updateAlarmsFromDatabase(propertiesToUpdate : [String : Any] , identifier : String?) -> () {
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: entityName)
        //有标识符更新指定数据    没有则更新全部数据
        if let _ = identifier {
            batchUpdateRequest.predicate =  NSPredicate(format : "identifier = %@",identifier!)
        }
        
        //需要更新的属性
        batchUpdateRequest.propertiesToUpdate = propertiesToUpdate
        
        //设置更新后返回结果的类型  这里是更新的条目数
        batchUpdateRequest.resultType = .updatedObjectsCountResultType
        
        //执行批量更新
        do {
            let batchResult = try managedContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            print("Records updated at \(batchResult.result!)")
            
            //由于NSBatchUpdateRequest并不会先将数据存入内存，而是直接操作数据库，所以并不会引起NSManagedObjectContext的同步更新，所以需要获取NSBatchUpdateResult然后刷新NSManagedObjectContext对应的数据和UI界面
            managedContext.refreshAllObjects()
            
            
        } catch let error as NSError {
            assert(false, error.userInfo.debugDescription)
        }
        
    }
    
    
    
    
    
    
    
    //1
    lazy var managedContext : NSManagedObjectContext = {
        return (UIApplication.shared.delegate as! AppDelegate) .managedObjectContext
    }()
    
    lazy var storeCoordinator: NSPersistentStoreCoordinator = {
        return (UIApplication.shared.delegate as! AppDelegate) .persistentStoreCoordinator
    }()
    
    
    fileprivate let entityName = "AlarmInfosEntiy"
    
    
}



