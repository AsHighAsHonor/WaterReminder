//
//  String+Reflect.swift
//  WaterReminder
//
//  Created by YYang on 23/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation

extension String{
    static public func classReflect(classStr : String) -> AnyClass? {
        //动态获取命名空间(CFBundleExecutable这个键对应的值就是项目名称,也就是命名空间)
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        //将字符串转化为类
        //默认情况下,命名空间就是项目名称,但是命名空间是可以修改的
        let cls : AnyClass? = NSClassFromString(nameSpace + "." + classStr)
        
        //返回class对象
        return cls
    }
}
