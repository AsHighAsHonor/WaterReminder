//
//  UIColorExtension.swift
//  WaterReminder
//
//  Created by YYang on 02/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
public extension UIColor {
    
    public class func colorWithRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let base: CGFloat = 255.0
        return UIColor(red: red/base, green: green/base, blue: blue/base, alpha: alpha)
    }
    
    public class func colorWithHex(_ hex: Int, alpha: Float = 1.0) -> UIColor {
        let blue = hex & 0xFF
        let green = (hex >> 8) & 0xFF
        let red = (hex >> 16) & 0xFF
        return self.colorWithRGB(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    public class func colorWithHexString(_ hexString: String, alpha: Float = 1.0) -> UIColor {
        var hexStr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if (hexStr.hasPrefix("#")) {
            hexStr = hexStr.substring(from: hexStr.index(after: hexStr.startIndex))
        }
        var hex:CUnsignedInt = 0
        Scanner.init(string: hexStr).scanHexInt32(&hex)
        
        let blue = hex & 0xFF
        let green = (hex >> 8) & 0xFF
        let red = (hex >> 16) & 0xFF
        return self.colorWithRGB(CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
