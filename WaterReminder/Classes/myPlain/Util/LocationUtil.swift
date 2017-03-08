//
//  LocationUtil.swift
//  WaterReminder
//
//  Created by YYang on 27/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import CoreLocation


class LocationUtil: NSObject ,CLLocationManagerDelegate {
    var locateManager = CLLocationManager()
    var locateUpdateHandler : ((_ :CLLocationManager , _ : [CLLocation])->Void)?
    var placeMarkHandler : ((_ :CLPlacemark)->Void)?
    
    func requestLocateAuthorization(handler : ((_ result : Bool)->Void)) {
        
        //1.检查是否开启定位
        guard CLLocationManager.locationServicesEnabled()  else {
            handler(false)
            return
        }
        
        //2.检查是否允许获取位置信息
        guard CLLocationManager.authorizationStatus() == .authorizedAlways else {
            locateManager.requestAlwaysAuthorization()
            handler(false)
            return
        }
        
        setupLocate()
        
        //3.授权成功
        handler(true)
        
    }
    
   private func setupLocate() -> () {
        locateManager.delegate = self
        locateManager.desiredAccuracy = kCLLocationAccuracyBest//定位精准度
        locateManager.distanceFilter = 5000 //位置更新最小距离5000m
    }
    
   public func startLocating() -> () {
        locateManager.startUpdatingLocation()
    }
    
     // MARK: - 当位置发生改变的时候调用(上面我们设置的是5000米,也就是当位置发生>5000米的时候该代理方法就会调用)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let newLoca = locations.last {
            /*
             使用位置前, 务必判断当前获取的位置是否有效
             如果水平精确度小于零, 代表虽然可以获取位置对象, 但是数据错误, 不可用
             */
            if newLoca.horizontalAccuracy < 0 {
                YYPrint("数据错误不可用")
                return
            }
            
            CLGeocoder().reverseGeocodeLocation(newLoca, completionHandler: { (pms, err) -> Void in
                
                guard (pms != nil) && (err == nil)  else {
                    YYPrint("逆地理错误====>>> \(err)")
                    return
                }
                
                guard (pms != nil) else {
                    YYPrint("获取地址信息失败")
                    return
                }
                
                guard !(pms!.isEmpty) else {
                    YYPrint("找不到地址信息")
                    return
                }
                
                if (pms?.last?.location?.coordinate) != nil {
                    //此处设置地图中心点为定位点，缩放级别18
                    manager.stopUpdatingLocation()//停止定位，节省电量，只获取一次定位
                    
                    //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                    if let placemark = pms?.last {
                        self.placeMarkHandler?(placemark) //定位结果回调
                    }
                  
                }
            })
        }
    }
    
    
   /// 反地理编码  根据经纬度查坐标(名字)
   ///
   /// - Parameters:
   ///   - location: 地理位置信息
   ///   - completionHandler: 回调
   public func reverseGeocode(location: CLLocation, completionHandler: @escaping CLGeocodeCompletionHandler)  {
         CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }
    
   
    
    
    
}
