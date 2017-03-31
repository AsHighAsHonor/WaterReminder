//
//  CacheUtil.swift
//  WaterReminder
//
//  Created by YYang on 27/01/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation


/// 水量类型
///
/// - TargetWater: 每日目标水量
/// - DrinkingWater: 已饮水量
public enum WaterType {
    case TargetWater (Double)
    case DrinkingWater (Double)
}


/// 水量增减
///
/// - Add: 增
/// - Subtract: 减
public enum Operation {
    case Add(Double)
    case Subtract(Double)
}


/// 默认设置的保存
///
/// - AlarmToggle: 是否开启提醒
/// - TurnOffWhenFinished: 当天目标完成后关闭提醒
public enum UserSetting : String{
    case AlarmToggle = "AlarmToggle"
    case TurnOffWhenFinished = "TurnOffWhenFinished"
    case DailyMark = "DailyMark"
    case CurrentCity = "CurrentCity"
    case CurrentCountry = "CurrentCountry"
    case LocationHistory = "LocationHistory"
}


public class CacheUtil {
    
    static let TargetWater = "TargetWater"
    static let DrinkingWater = "DrinkingWater"
   public static let userDefaults = UserDefaults(suiteName: "group.com.ZTESoft.app")!
    

     // MARK: - 水量相关
    ///保存水量
    class public func saveWaterBy(waterType :WaterType) -> () {
        switch waterType {
        case .TargetWater(let targerValue):
            userDefaults.set(targerValue, forKey:TargetWater)
        case .DrinkingWater(let drinkValue):
            userDefaults.set(drinkValue, forKey:DrinkingWater)
        }
        
        //保存每日时间戳
        userDefaults.set(String().dailyMark(), forKey:UserSetting.DailyMark.rawValue)

        userDefaults.synchronize()
    }
    
    ///删除水量
  class public func deleteWater(type waterType :WaterType) {
    switch waterType {
    case .TargetWater:
        userDefaults.removeObject(forKey: TargetWater)
    case .DrinkingWater:
        userDefaults.removeObject(forKey: DrinkingWater)
    }
    userDefaults.synchronize()
    print("目标============>>\(userDefaults.object(forKey:TargetWater))")
    print("完成============>>\(userDefaults.object(forKey:DrinkingWater))")


}
    ///获取水量
  class public func readWater(type waterType :WaterType) -> Double {
    switch waterType {
    case .TargetWater:
        if let water = userDefaults.object(forKey:TargetWater) as? Double {
            return water
        }else{
            return 1
        }
    case .DrinkingWater:
        if let water = userDefaults.object(forKey: DrinkingWater) as? Double {
            return water
        }else{
            return 0.0
        }
    }
}
    
    
    
    ///计算喝水进度
    class public func progressCalculatorBy(operation : Operation) -> Double {
        switch operation {
        case .Add(let waterValue):  //增加
            let drinkingWater =  self.readWater(type: .DrinkingWater(0))
            let newWater = waterValue + drinkingWater
            self.saveWaterBy(waterType: .DrinkingWater(newWater))
            let result = newWater/self.readWater(type: .TargetWater(0))
            return  result >= 1 ?1.0:result   //进度总量永远不超过100%
            
        case .Subtract(let waterValue):  //减少
            let drinkingWater =  self.readWater(type: .DrinkingWater(0))
            let newWater = drinkingWater - waterValue
            if newWater < 0 {
                self.saveWaterBy(waterType: .DrinkingWater(0))
            }else{
                self.saveWaterBy(waterType: .DrinkingWater(newWater))
            }
            return newWater/self.readWater(type: .TargetWater(0))
        }
    }
    

    
    
     // MARK: - 校验
    
   class public func waterChecker(water : Double) -> Bool {
        //校验目标水量
        if water < 100 || water > 3000 {
            return false
        }else{
            return true
        }
    }
    

    
     // MARK: - 配置保存
    
    /// 用户配置
    ///
    /// - Parameters:
    ///   - toggle: 开启/关闭  可选值  当传nil时 表示获取配置(取)
    ///   - setting: 设置key
    /// - Returns: nil(存) / 获取用户设置值(取)
    public class func userSettingOperation(toggle : Any? , setting : UserSetting) -> (Any?) {
    if let toggle = toggle {
        userDefaults.set(toggle, forKey:setting.rawValue)
        userDefaults.synchronize()
        return nil
    }else{
        return userDefaults.object(forKey: setting.rawValue)
    }
        
}
    
  /// 保存/读取 数据的共用方法
  ///
  /// - Parameters:
  ///   - value: 需要保存的值 (传入nil 的时候为获取值)
  ///   - forkey: key
  /// - Returns:  读取的值
  public class func userDefaultsOperation(value : Any? , key forkey : UserSetting) -> (Any?) {
        if let value = value {
            userDefaults.set(value, forKey:forkey.rawValue)
            userDefaults.synchronize()
            return nil
        }else{
            return userDefaults.object(forKey: forkey.rawValue)
        }
    }
    
    


}
