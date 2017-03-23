//
//  UIViewController+Toast.swift
//  WaterReminder
//
//  Created by YYang on 14/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD
import Toast_Swift


extension UIViewController {
    
    
    /// toast
    ///
    /// - Parameter msg: 消息内容
    func toast(msg : String) {
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(msg, duration: 2.0, position: .bottom)
    }
    
    func longToast(msg : String) {
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(msg, duration: 5.0, position: .bottom)
    }
    
    /// 自定义风格的 toast
    ///
    /// - Parameters:
    ///   - msg:  消息内容
    ///   - StyleTuples: customStyle
    func customToast(msg : String ,StyleTuples : (name : String , msgColor : UIColor ,backColor :UIColor,position : ToastPosition )) -> () {
        var style = ToastStyle()
        style.messageFont = UIFont(name: StyleTuples.name, size: 14.0)!
        style.messageColor = StyleTuples.msgColor
        style.messageAlignment = .center
        style.backgroundColor = StyleTuples.backColor
        
         UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(msg, duration: 2.0, position: StyleTuples.position, style: style)
    }
    
    
    
    /// 自定义 view 的 toast
    ///
    /// - Parameters:
    ///   - customView:  自定义 view
    ///   - toastPosition: toast 位置
    func viewToast(customView : UIView , Position toastPosition : ToastPosition ,Complete handler : ((Bool) -> Void)?) -> () {
        UIApplication.shared.keyWindow?.rootViewController?.view.showToast(customView, duration: 3.0, position: toastPosition, completion:handler)
    }
    
    
    /// 带图片标题的 Toast
    ///
    /// - Parameters:
    ///   - imageTuples:  图片
    ///   - handler: 点击回调
    func imageToast(imageTuples : (titile : String , msg : String , image : String) ,Complete handler : (((Bool) -> Void)?)) -> () {
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(imageTuples.msg, duration: 2.0, position: .bottom, title: imageTuples.titile, image: UIImage(named:imageTuples.image), style: nil, completion: handler)
    }

    
    
        
    
 
    

    
    
    
}
