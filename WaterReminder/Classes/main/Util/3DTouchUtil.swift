//
//  3DTouchUtil.swift
//  WaterReminder
//
//  Created by YYang on 31/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import UIKit


class TouchUtil {
    
    static let sharedInstance: TouchUtil = {
        let instance = TouchUtil()
        return instance
    }()
    
    
    /// 检测设备是否支持3d - touch
    ///
    /// - Returns: true/false
    public func fourceTouchCapability(controller : UIViewController) -> Bool {
        //1.系统版本
        guard #available(iOS 9.0, *) else {
            return false
        }
        //2.判读是否支持forceTouch
        guard controller.traitCollection.forceTouchCapability == UIForceTouchCapability.available else {
            return false
        }
        
        return true
    }
    
}

