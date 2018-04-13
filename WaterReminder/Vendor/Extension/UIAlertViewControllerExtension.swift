//
//  UIAlertViewControllerExtension.swift
//  WaterReminder
//
//  Created by YYang on 02/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    /// 展示只有"确定"按钮的 alert
    ///
    /// - Parameters:
    ///   - message:  提示内容
    ///   - viewController:  Owner
    static func showConfirmAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定".localized(), style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    
    ///  在 rootVC展示只有"确定"按钮的 alert
    ///
    /// - Parameter message: 提示内容
    static func showConfirmAlertFromTopViewController(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirmAlert(message: message, in: vc)
        }
    }
    
    /// 展示"确定"/"取消"按钮的 alert
    ///
    /// - Parameters:
    ///   - message:  提示内容
    ///   - viewController:  owner
    ///   - Handler: 点击确定回调
    static func showAlert(message: String, in viewController: UIViewController ,sureHandler sure : ((UIAlertAction)->Void)? , cancelHandler cancel:((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: "提示".localized(), message: message, preferredStyle: .alert)
        
        let sureAct = UIAlertAction(title: "确定".localized(), style: .default
            , handler: sure)
        alert.addAction(sureAct)
        alert.addAction(UIAlertAction(title: "取消".localized(), style: .default , handler: cancel))
        
        viewController.present(alert, animated: true)
    }
    
    
    /// 弹出提示跳转用户权限设置页面的提醒
    ///
    /// - Parameters:
    ///   - message: 提示信息
    static func showAuthorizationAlert( msg message : String , ancelHandler cancel:((UIAlertAction)->Void)?) {
        UIAlertController.showAlert(message: message, in: (UIApplication.shared.keyWindow?.rootViewController)!, sureHandler: { (UIAlertAction) in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: { (Bool) in
                })
            }
            
        }, cancelHandler: cancel)
    }
    
    
}
