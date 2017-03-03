//
//  Common.swift
//  WaterReminder
//
//  Created by YYang on 24/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation

// MARK:- 自定义打印方法
func YYPrint<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):(\(lineNum))-\(message)")
        
    #endif
}
