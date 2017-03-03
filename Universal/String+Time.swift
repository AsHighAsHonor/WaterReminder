//
//  String+Time.swift
//  WaterReminder
//
//  Created by YYang on 15/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation

 extension String{
    
    /// 每天的时间戳  "年月日"
    ///
    /// - Returns: 时间戳
    func dailyMark() -> String {
        let date  = Date()
        let formatter =   DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }
}
