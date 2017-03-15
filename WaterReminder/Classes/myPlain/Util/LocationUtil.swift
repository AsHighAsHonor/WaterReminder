//
//  LocationUtil.swift
//  WaterReminder
//
//  Created by YYang on 27/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications


class LocationUtil: NSObject ,CLLocationManagerDelegate {
    
    
    // MARK: - InterfaceMthods
    /// 请求定位授权
    ///
    /// - Parameter handler: 回调
    func requestLocateAuthorization(handler : ((_ result : Bool)->Void)) {
        
        //1.检查是否开启定位
        guard CLLocationManager.locationServicesEnabled()  else {
            handler(false)
            return
        }
        
        //2.检查是否允许获取位置信息
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            locateManager.requestWhenInUseAuthorization()
            handler(false)
            return
        }
        setupLocate()
        
        //3.授权成功
        handler(true)
        
    }
    
    
    /// 开启定位
    public func startLocating() -> () {
        locateManager.startUpdatingLocation()
    }
    
    
    /// 停止定位
    public func endLocating() -> () {
        locateManager.stopUpdatingLocation()
    }
    
    /// 添加监测区域
    ///
    /// - Parameter region: CLRegion
    public  func startMonitoring(region : CLRegion) {
        // 1.设备是否含有进行围栏检测所需的硬件
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            UIAlertController.showConfirmAlertFromTopViewController(message: "该设备不支持区域监测!")
            return
        }
        // 2.开始监听
        YYPrint("监控区域=======>>\(region)")
        locateManager.startMonitoring(for: region)
        locateManager.requestState(for: region)
    }
    
    
    
    /// 移除区域监测
    ///
    /// - Parameter identifier: 移除的CLCircularRegion 标识符
    public func stopMonitoring(identifier : String) {
        for region in locateManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == identifier else{
                continue
            }
            locateManager.stopMonitoring(for: circularRegion)
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
    
    
    
    
    // MARK: - PrivateMethods
    
    /// 添加一条临时 timeInterval 触发的通知
    ///
    /// - Parameter identifier: 区域围栏标识符
    private func disposibleNotificationRequest(identifier: String) -> () {
        UNUserNotificationCenter.current().getPendingNotificationRequests {[unowned self] requests in
            for request in requests {
                //1.判断是位置触发的通知
                guard let tigger = request.trigger as? UNLocationNotificationTrigger else {
                    continue
                }
                
                //2.判断是当前区域的触发条件
                guard tigger.region.identifier == identifier else{
                    continue
                }
                //3.创建
                self.submitRequest(request: request)
                
            }
        }
    }
    
    private func submitRequest(request : UNNotificationRequest)  {
        let alarmInfo = AlarmInfo()
        alarmInfo.time = "1/60"
        alarmInfo.isRepeat = false
        alarmInfo.on = true
        alarmInfo.contentTitle = request.content.title
        alarmInfo.contentSubtitle = request.content.subtitle
        alarmInfo.contentBody = request.content.body
        alarmInfo.timeType = .Location
        // 添加一条新的一次性通知
        alarmModel.sendDisposableNotification(alarmInfoEntity: nil, alarmInfo: alarmInfo, identifier: nil) { (error) in
        }
    }
    
    
    
    
    private func setupLocate() -> () {
        locateManager.delegate = self
        locateManager.desiredAccuracy = kCLLocationAccuracyBest//定位精准度
        locateManager.distanceFilter = 5000 //位置更新最小距离5000m
        locateManager.pausesLocationUpdatesAutomatically = true //由系统决定何时自动暂停定位
        locateManager.allowsBackgroundLocationUpdates = true;
        
        
    }
    
    
    
    
    // MARK: - CLLocationManagerDelegateMethods
    
    //当位置发生改变的时候调用(上面我们设置的是5000米,也就是当位置发生>5000米的时候该代理方法就会调用)
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
                    
                    //取得最后一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
                    if let placemark = pms?.last {
                        self.placeMarkHandler?(placemark) //定位结果回调
                    }
                    
                }
            })
        }
    }
    
    
    // MARK: 这三个代理方法用于位置的监听   可以配合UNTimeIntervalNotificationTrigger 实现围栏监听
    /// 退出监测区域触发
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        disposibleNotificationRequest(identifier: region.identifier)
    }
    
    ///进入监测区域触发
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        disposibleNotificationRequest(identifier: region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        YYPrint("围栏监听失败====>>\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        YYPrint("区域状态:\(state.rawValue)")
    }
    
    
    
    // MARK: - Properties
    lazy var alarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    var locateManager = CLLocationManager() //CLLocationManager对象
    var placeMarkHandler : ((_ :CLPlacemark)->Void)? //成功获取定位后回调
    
    
    
    
}
