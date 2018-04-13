//
//  UIViewControllerExtension.swift
//  WaterReminder
//
//  Created by YYang on 14/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
extension UIViewController {
    /// 获取当前页面显示的ViewController
    ///
    /// - Returns: Current ViewController
    func getCurrentViewController() -> UIViewController {
        var resultVc : UIViewController!
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.shared.windows
            for win in windows {
                guard win.windowLevel != UIWindowLevelNormal else {
                    window = win
                    break
                }
            }
        }
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        if nextResponder.self === UIViewController.self  {
            resultVc = nextResponder as! UIViewController!
        }else{
            resultVc = window?.rootViewController
        }
        return resultVc
        
    }

    
    /// pop当前 vc 用于 closure 中
    func popVc() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
