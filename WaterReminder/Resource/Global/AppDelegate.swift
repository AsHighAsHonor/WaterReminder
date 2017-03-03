//
//  AppDelegate.swift
//  WaterReminder
//
//  Created by YYang on 24/01/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import IQKeyboardManagerSwift
import ChameleonSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let updateUIName = "updateUIName"

    private let umengAppKey = "58a6970af5ade43470001841"  //友盟推送
    //初始化 UNUserNotificationCenter 代理对象 ,NotificationUtil 实现了 UNUserNotificationCenter 2个代理方法  1.app 前台运行时提示通知  2.用户与通知交互时的回调方法
    let notificationHandler = NotificationUtil()
    
    let qucikActHandler = QuickActionHandler()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ///将UNUserNotificationCenter的代理设置为notificationHandler
        UNUserNotificationCenter.current().delegate = notificationHandler
        notificationHandler.registerNotiCategory()//注册本地通知action 簇
        
        UMessage.start(withAppkey: umengAppKey, launchOptions: launchOptions, httpsenable: true)
        UMessage.registerForRemoteNotifications() // 注册远程通知
        UMessage.setLogEnabled(true)//开启日志
        notificationHandler.dailyCheck() //检测每日水量
        IQKeyboardManager.sharedManager().enable = true  //开启键盘自适应
        // TODO: 重置颜色
//        ThemeServiceConfig.shared.initTheme(data: ThemeStyle.day) //设置整个 app 的 theme

        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        notificationHandler.dailyCheck() //检测每日水量
        pushNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        notificationHandler.dailyCheck() //检测每日水量

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // TODO: 应用间跳转传值
        return true
    }
    
   private func pushNotifications()  {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppDelegate.updateUIName), object: nil, userInfo: nil)
    }
    
    
    //MARK: - 通过quick Action 进入调用方法
    
    //在程序启动顺序方面，启动程序和使用快捷操作唤醒是有区别的。通过快捷操作启动, 程序启动会调用willFinishLaunchingWithOptions和didFinishLaunchingWithOptions , performActionForShortcutItem方法。但是当使用快捷操作唤醒时，只会触发performActionForShortcutItem方法 ,只走这一个方法

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(qucikActHandler.actionHandler(shortcutItem))
    }
    
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "WaterAlarmInfos", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
}

