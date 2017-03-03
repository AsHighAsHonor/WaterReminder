//
//  UIImage+Color.swift
//  WaterReminder
//
//  Created by YYang on 24/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation


extension UIImage{
   static public func generateImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
