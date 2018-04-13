//
//  UITableViewExtension.swift
//  WaterReminder
//
//  Created by YYang on 12/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit


public struct ReusableIdentifier <T : UIView> {
     let reuserId : String = String( describing: T.self )

}

extension  UITableView {
    
    
    /// 定义一个通用方法用来实现 cell 的注册
    ///
    /// - Parameter _: 受UITableViewCell 类型约束的类型的类型(AnyClass)
    public func registeCell<T: UITableViewCell>(_: T.Type , isClass : Bool) {
        if isClass {
            self.register(T.self, forCellReuseIdentifier: ReusableIdentifier<T>().reuserId)
        }else{
            self.register(UINib(nibName: ReusableIdentifier<T>().reuserId , bundle: nil), forCellReuseIdentifier: ReusableIdentifier<T>().reuserId)
        }
    }
    
    
   /// 定义一个通用的重用 cell 的泛型方法
   ///
   /// - Parameter IndexPath:  indexPath
   /// - Returns: cell
   public func dequeue<T : UITableViewCell>(IndexPath : IndexPath ) -> T {
       let cell = self.dequeueReusableCell(withIdentifier: ReusableIdentifier<T>().reuserId, for: IndexPath)
        if ((cell as? T) != nil){
            return cell as! T
        }else{
            return T()
        }
    }
    
}
