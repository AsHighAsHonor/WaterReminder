//
//  QuickActionHandler.swift
//  WaterReminder
//
//  Created by YYang on 23/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit

class QuickActionHandler: NSObject {
    
    /// quickAction 进入app后触发的回调方法
    ///
    /// - Parameter shortcutItem:  type
    /// - Returns: return value description
    public func actionHandler(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        //根据 type判断跳转的位置
        if shortcutItem.type .contains("Prefs:") {
            //跳转系统设置
            ocHealper.jumpToSystemPreference(withPrefs: shortcutItem.type)
            return true
        }else{
            //跳转其他功能页面  shortcutItem.type 设置成为对应控制器类名 通过反射获得
            return  pushToTargetController(className: shortcutItem.type)
        }
    }
    
    //只有OC 可以调用私有方法进入系统设置
    lazy var ocHealper : OChelper = {OChelper()}()
    
    
    
    // 获取根控制器 tabVC  -> 获取 nav ->推出 ->目标控制器  此时 nav 中只有一个目标控制器 , 推测在页面显示后其余的 viewcontroller 才由 storyboard 加载进 nav 栈中
   private  func pushToTargetController(className : String)->Bool {
        //reflect 反射获取目标控制器
        let someClass : AnyClass? = String.classReflect(classStr: className)
        //获取 tabVC
        let tab = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController
        
        if let  someVc = (someClass as? UIViewController.Type)?.init(), //目标控制器
            let nav = tab?.selectedViewController as? UINavigationController{//导航Nav
            if nav.viewControllers.contains(someVc) {
                _ = nav.popToViewController(someVc, animated: true)
            }else{
                nav.pushViewController(someVc, animated: true)
            }
            return true
        }else{
            return false
        }
        
    }

}
