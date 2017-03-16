//
//  WaterAddLocationMapController.swift
//  WaterReminder
//
//  Created by YYang on 27/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import JZLocationConverter

class WaterAddLocationMapController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.backValue()
    }
    
    //持有传值
    var alarmInfo : AlarmInfo!
    
    //接受上个页面传入的提醒信息  != nil  修改模式
    var alarmInfosEntiy : AlarmInfosEntiy?
    
    //地图工具
    fileprivate let mapUtil = LocationUtil()
    
    
    //MKMap
    @IBOutlet weak  var myMapView: MKMapView!
    
    //地理信息 textview
    @IBOutlet weak var placeTextView: UITextView!
    //缩放按钮 stepper
    @IBOutlet weak var scalingStepper: UIStepper!
    // 半径 textfield
    @IBOutlet weak var radiusTextField: UITextField!
    
    /// 离开区域
    @IBOutlet weak var leaveSwitch: UISwitch!
    
    /// 进入区域
    @IBOutlet weak var enterSwitch: UISwitch!
}

// MARK: - EventResponses
extension WaterAddLocationMapController{
    
    
    //回到设备所在位置
    @IBAction func currectLocationClicked(_ sender: UIButton) {
        myMapView.setCenter(myMapView.userLocation.coordinate, animated: true)
    }
    
    //进入/离开区域
    @IBAction func regionSwitchToggleClicked(_ sender: UISwitch) {
        switch sender.tag {
        case 20:
            if sender.isOn {
                toast(msg: "当进入指定区域时提醒开启")
            }
            alarmInfo.onEnter = sender.isOn
        case 21:
            if sender.isOn {
                toast(msg: "当离开指定区域时提醒开启")
            }
            alarmInfo.onExit = sender.isOn
        default:
            break
        }
        
    }
    //缩放
    @IBAction func scaleStepperClicked(_ sender: UIStepper) {
        let previousValue = sender.tag
        let delta = Int(sender.value) - previousValue
        if (delta < 0) {
            self.myMapView.zoomMap(byFactor: 1.5)
        } else {
            self.myMapView.zoomMap(byFactor: 1.0/1.5)
        }
        sender.tag = Int(sender.value)
    }
}

// MARK: - PrivateMethods
extension WaterAddLocationMapController {
    
    func setUp() {
        //配置 textview 边框
        placeTextView.setFrameBorder(width: 1, cornerRadius: 5, borderColor: "CFCFCF")
        
        
        if let alarmInfosEntiy = alarmInfosEntiy {
            //修改模式
            //读取开关状态
            alarmInfo.onEnter = alarmInfosEntiy.onEnter
            alarmInfo.onExit = alarmInfosEntiy.onExit
            //设置 switch 状态
            leaveSwitch.setOn((alarmInfosEntiy.onExit), animated: true)
            enterSwitch.setOn((alarmInfosEntiy.onEnter), animated: true)
            //读取半径
            radiusTextField.text = String(describing: alarmInfosEntiy.radius)
            //            placeTextView.text = "\(alarmInfosEntiy.showTitle) \n \(alarmInfosEntiy.time)"
            //读取位置
            let locations = alarmInfosEntiy.time!.components(separatedBy: "+")//从alarmInfo.time是由"latitude + longitude "拼接的字符串
            let center = CLLocationCoordinate2D(latitude: Double(locations.first!)!, longitude: Double (locations.last!)!)
            //设置地图中心 并缩放
            myMapView.setMapCenterAndZoom(center: center)

        }else{
            //默认进入区域提醒开启 离开区域关闭
            alarmInfo.onEnter = true
            alarmInfo.onExit = false
        }
    }
    
    func setupMap() -> () {
        
        guard alarmInfosEntiy == nil else {
            return
        }
        //设置地图用户位置追踪模式  定位后自动缩放显示当前位置
        self.myMapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    /// 返回页面时候传值
    fileprivate func backValue()  {
        alarmInfo.isRepeat = true
        alarmInfo.contentBadge = 0
        alarmInfo.timeType = AlarmType.Location
        alarmInfo.on = true
        alarmInfo.contentSubtitle = ""
        
        //校验radius 是否设置
        guard let radiusStr = radiusTextField.text ,let radiusDou = Double(radiusStr)  else {
            alarmInfo.radius = NSNumber(value: 20)  //没有设置默认传20m
            return
        }
        let radius = NSNumber(value: radiusDou)
        alarmInfo.radius = radius
        
        
    }
    
    
    /// 请求定位权限
    fileprivate func requestLocal()  {
        mapUtil.requestLocateAuthorization { (result) in
            if result{
                setupMap() //配置地图
                setUp() //配置页面
                mapUtil.startLocating() //开启定位
                
            }else{
                // 尚未获取到定位权限/未开启定位
                UIAlertController.showAuthorizationAlert(msg: "您尚未允许定位权限或未开启定位服务,是否进入设置页面开启?", ancelHandler: { (act) in
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
    
}

// MARK: - MapView 代理方法
extension WaterAddLocationMapController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location  = userLocation.location {
            YYPrint(location.description)
            /*
             使用位置前, 务必判断当前获取的位置是否有效
             如果水平精确度小于零, 代表虽然可以获取位置对象, 但是数据错误, 不可用
             */
            if location.horizontalAccuracy < 0 {
                YYPrint("数据错误不可用")
                return
            }
            
            //反地理信息获取详细地址信息
            self.mapUtil.reverseGeocode(location: location) { (placeMarks, error) in
                guard (placeMarks != nil) && (error == nil)  else {
                    YYPrint("逆地理错误====>>> \(error)")
                    return
                }
                
                guard (placeMarks != nil) else {
                    YYPrint("获取地址信息失败")
                    return
                }
                
                guard !(placeMarks!.isEmpty) else {
                    YYPrint("找不到地址信息")
                    return
                }
                
                //设置地图上显示的内容  (placeMarks?.last? 当前详细地标)
                userLocation.title = placeMarks?.last?.locality
                userLocation.subtitle = placeMarks?.last?.name
                
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        guard !hud.isVisible  else {
            return
        }
        //        showHud(msg: "位置获取中...")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        //        guard !hud.isVisible  else {
        //            return
        //        }
        //        showHud(msg: "加载中...")
    }
    
    //显示在当前屏幕的地图区域改变则调用的代理方法
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        YYPrint("当前地图中央坐标 =====>> \(center)")
        
        //1.经纬度生成位置
        let location =  CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        /*
         使用位置前, 务必判断当前获取的位置是否有效
         如果水平精确度小于零, 代表虽然可以获取位置对象, 但是数据错误, 不可用
         */
        if location.horizontalAccuracy < 0 {
            YYPrint("数据错误不可用")
            return
        }
        
        //2.反地理 查名称
        mapUtil.reverseGeocode(location: location) {[unowned self] (placeMarks, error) in
            guard (placeMarks != nil) && (error == nil)  else {
                YYPrint("逆地理错误====>>> \(error)")
                return
            }
            
            guard (placeMarks != nil) else {
                YYPrint("获取地址信息失败")
                return
            }
            
            guard !(placeMarks!.isEmpty) else {
                YYPrint("找不到地址信息")
                return
            }
            
            YYPrint("选中地址信息: \n \(placeMarks!.last?.addressDictionary!)")
            
            
            if let addDict = placeMarks!.last?.addressDictionary{
                let addressLines = (addDict["FormattedAddressLines"])!
                let ss = addressLines as!Array<Any>
                
                var addStr = ""
                for (_ , obj ) in ss.enumerated(){
                    addStr.append(obj as! String)
                }
                
                //火星坐标需要转换成 GPS 坐标
                let wgsCenter = JZLocationConverter.gcj02(toWgs84: center)
                
                //保存围栏区域GPS 坐标
                self.alarmInfo.time =  "\(wgsCenter.latitude)+\(wgsCenter.longitude)"
                self.alarmInfo.contentTitle = addStr
                self.alarmInfo.showTitle = addStr
                
                
                //显示地址 GPS 坐标
                self.title = addDict["Street"] as! String?
                self.placeTextView.text = "\(addStr) \n \(wgsCenter.latitude) \(wgsCenter.longitude)"
                
                //                self.hideHud()
            }
            
        }
    }
    
}





