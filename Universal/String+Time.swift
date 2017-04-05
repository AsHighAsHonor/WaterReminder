//
//  String+Time.swift
//  WaterReminder
//
//  Created by YYang on 15/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation

extension String{
    
   static public func dateStr(fromat : String) -> String {
        let date  = Date()
        let formatter =   DateFormatter()
        formatter.dateFormat = fromat
        let dateStr = formatter.string(from: date)
        print("dateStr--------->>\(dateStr)")
        return dateStr
    }
}
