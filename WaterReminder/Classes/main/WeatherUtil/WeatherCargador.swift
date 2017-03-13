//
//  WeatherCargador.swift
//  WaterReminder
//
//  Created by YYang on 03/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Universal


class WeatherCargador: NSObject {
    let mapUtil = LocationUtil()
    
   public func requestLoacteAuthorizationAndFetchWeaterData(completionHandler : @escaping (DataResponse<Any>) -> Void) {
        mapUtil.requestLocateAuthorization { (result) in
            if result{
                mapUtil.startLocating() //开启定位
                
                //当位置发生改变符合设置的频率时候回调方法
                mapUtil.placeMarkHandler = {[unowned self] placemark in
                    let city = placemark.locality
                    let country = placemark.isoCountryCode
                    YYPrint("\(city)---------\(country)")
                    //保存当前的位置
                    _ = CacheUtil.userDefaultsOperation(value: city, key: UserSetting.CurrentCity)
                    _ = CacheUtil.userDefaultsOperation(value: country, key: UserSetting.CurrentCountry)
                    //根据当前地理位置查询城市天气
                    self.fetchWeatherData(cityName: city!, Code: country!, completionHandler: completionHandler)
                }
            }else{
                // 尚未获取到定位权限/未开启定位
                UIAlertController.showAuthorizationAlert(msg: "您尚未允许定位权限或未开启定位服务,是否进入设置页面开启?", ancelHandler: { [unowned self](act) in
                    
                    // 获取上次保存的位置   如果没保存位置 默认使用北京
                    let city = CacheUtil.userDefaultsOperation(value: nil, key: UserSetting.CurrentCity)
                    let country = CacheUtil.userDefaultsOperation(value: nil, key: UserSetting.CurrentCountry)
                    if let cityStr = city as? String , let countryStr = country as? String {
                        self.fetchWeatherData(cityName: cityStr, Code: countryStr, completionHandler: completionHandler)
                    }else{
                        self.fetchWeatherData(cityName: "Beijing", Code: "CN", completionHandler: completionHandler)
                    }
                    
                })
            }
        }
    }
    
    private func fetchWeatherData(cityName : String , Code countryCode : String , completionHandler : @escaping (DataResponse<Any>) -> Void)  {
        
        let urlStr = "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='\(cityName), \(countryCode)')&format=json&env=store://datatables.org/alltableswithkeys"
        
        let url = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        YYPrint(url)
        //string -> url 时候 因为 str 中含有 url 不允许的特殊字符  需要在使用前进行编码
        let _=Alamofire.request(url!).responseJSON(completionHandler: completionHandler)
    }
    
    
   /// 华氏->摄氏
   ///
   /// - Parameter Fahrenheit: 华氏温度
   /// - Returns: 摄氏温度
   public func temperatureTransfer(Fahrenheit : Float) -> Float {
        return (Fahrenheit - 32)/1.8
    }
    
}
