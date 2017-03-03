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
        locateManager.desiredAccuracy = kCLLocationAccuracyBest//定位精准度
        locateManager.distanceFilter = 10 //位置更新最小距离50m
    }
    
   public func startLocating() -> () {
        locateManager.startUpdatingLocation()
    }
    
     // MARK: - 定位获取到位置后立即调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newLoca = locations.last {
            CLGeocoder().reverseGeocodeLocation(newLoca, completionHandler: { (pms, err) -> Void in
                
                print("error------>>\(err)")
                if (pms?.last?.location?.coordinate) != nil {
                    //此处设置地图中心点为定位点，缩放级别18
                    manager.stopUpdatingLocation()//停止定位，节省电量，只获取一次定位
                    
                    //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                    let placemark:CLPlacemark = (pms?.last)!
                    let location = placemark.location;//位置
                    let region = placemark.region;//区域
                    let addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
                    //                    let name=placemark.name;//地名
                    //                    let thoroughfare=placemark.thoroughfare;//街道
                    //                    let subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
                    //                    let locality=placemark.locality; // 城市
                    //                    let subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
                    //                    let administrativeArea=placemark.administrativeArea; // 州
                    //                    let subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
                    //                    let postalCode=placemark.postalCode; //邮编
                    //                    let ISOcountryCode=placemark.ISOcountryCode; //国家编码
                    //                    let country=placemark.country; //国家
                    //                    let inlandWater=placemark.inlandWater; //水源、湖泊
                    //                    let ocean=placemark.ocean; // 海洋
                    //                    let areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
                    print(location!,region!,addressDic!)
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
