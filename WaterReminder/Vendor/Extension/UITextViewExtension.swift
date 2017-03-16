//
//  UITextViewExtension.swift
//  WaterReminder
//
//  Created by YYang on 16/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation


extension UITextView{

    
    /// 设置边框
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - radius: 圆角
    ///   - color: 颜色
    func setFrameBorder(width : CGFloat , cornerRadius radius : CGFloat, borderColor color : String )  {
        self.layer.borderWidth =  width
        self.layer.cornerRadius = radius;//设置圆角弧度。
        self.layer.masksToBounds = true;
        self.layer.borderColor =  UIColor.colorWithHexString(color).cgColor
    }
    
    
}
