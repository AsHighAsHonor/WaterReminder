//
//  WaterAddLocationTableController.swift
//  WaterReminder
//
//  Created by YYang on 28/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import UserNotifications
import Universal
import CoreLocation




/// 保存子页面返回的值
private struct RecivedValues {
    var  recivedLocation : [String : CLLocationCoordinate2D]? //[地理位置Str : CLLocationCoordinate2D]
    var  recivedContent : String? //提醒内容
}

class WaterAddLocationTableController: UITableViewController {
    private var recivedValues = RecivedValues()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //懒加载导航右按钮
        self.navigationItem.rightBarButtonItem = saveBtn
        
        //申请通知权限
        NotificationUtil.requestNotificationAuthorization()
        
        if let alarmInfosEntiy = alarmInfosEntiy {
            deleteMapBtn.isHidden = false
            details = [alarmInfosEntiy.showTitle!,alarmInfosEntiy.body!]
            locationStr = ""
        }else{
            details = ["请点击选择地址","基于地理位置的提醒"]
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setModifyAlarmPage()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell : UITableViewCell = tableView.dequeue(IndexPath: indexPath)
        
        //这里 cell 的复用要用传统方式才能设置 style
        let reid =  String(describing: UITableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier:reid)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reid)
        }
        cell?.detailTextLabel?.text = details?[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "地址:"
        case 1:
            cell?.textLabel?.text = "内容:"
        default:
            break
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: //跳转地图
            performSegue(withIdentifier:SegueId.AddMapSegue.rawValue , sender: nil)
        case 1://跳转设置提示语
            performSegue(withIdentifier: SegueId.AddContentSegue.rawValue, sender: nil)
        default:
            break
        }
    }
    
    
    // MARK: - LifeCycle
    
    // MARK: - Initliazation
    
    // MARK: - DelegateMethods
    
    
    
    // MARK: - EventResponses
    
    @IBAction func deleteMapBtnClicked(_ sender: UIButton) {
        UIAlertController.showAlert(message: "挨千刀的  确定要删除洒家吗?!", in: self, sureHandler: { (UIAlertAction) in
            self.alarmModel.removeNotification(alarmInfoEntitys : [self.alarmInfosEntiy!], fromDatabase: true)
            _ = self.navigationController?.popViewController(animated: true)
        }, cancelHandler: nil)

    }
    
    func saveBtnClicked()  {
        //1.检查是否选择了位置
        guard (recivedValues.recivedLocation != nil) else {
            toast(msg : "请到先选择地址!")
            return
        }
        
        //2.检查通知权限
        //authorizationStatus 有三种状态  notDetermined(未请求)/denied(拒绝)/authorized(通过)
        UNUserNotificationCenter.current().getNotificationSettings {
            self.notificationSettings = $0
            guard $0.authorizationStatus == .authorized else{
                return
            }
            //保存提醒
            self.addAlarm()
        }
        
    }
    
    
    // MARK: - PrivateMethods
    private func setModifyAlarmPage()  {
        
        //检查用户通知权限 trailing closure
        UNUserNotificationCenter.current().getNotificationSettings {
            self.notificationSettings = $0
        }
        
    }
    
    private func addAlarm() -> () {
        
        var identifier : String?
        if alarmInfosEntiy != nil {//判断是否是修改
            identifier = alarmInfosEntiy?.identifier
        }
        
        //提交提醒请求
        alarmModel.sendNotification(alarmInfoEntity : alarmInfosEntiy , alarmInfo: assignedAlarmInfo, identifier : identifier , withCompletionHandler: { error in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription , in : self)
            }else{
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination
        
        switch destinationVc {
        case is WaterAddLocationContentController:
            let vc  =   (destinationVc as!WaterAddLocationContentController)
            if let alarmInfosEntiy = alarmInfosEntiy { //修改进入
                vc.content = alarmInfosEntiy.body!
            }
            //设置 vc 的回调方法
            vc.deliverContentClosuer = {content in
                self.details?[1] = content  //修改 table 对应数据源
                self.recivedValues.recivedContent = content  //保存内容到recivedValues中
            }
        case is WaterAddLocationMapController:
            let vc : WaterAddLocationMapController =  (destinationVc as! WaterAddLocationMapController)

            vc.selectedLocationClosuer = { location in
                self.details?[0] = location.keys.first!  //修改 table 对应数据源
                self.recivedValues.recivedLocation = location //保存地址到recivedValues中
            }
        default:
            break
        }
    }
    
    // MARK: - Properties
    
    //接受上个页面传入的提醒信息
    var alarmInfosEntiy : AlarmInfosEntiy? = nil
    
    var notificationSettings : UNNotificationSettings?{
        didSet{
            if notificationSettings?.authorizationStatus != .authorized  {
                //用户未获取到通知权限
                //  提示跳转到系统设置 通知权限
                UIAlertController.showAuthorizationAlert(msg : "用户尚未允许通知权限 , 请到先进入 设置>通知> WaterRemainder 中开启 , 允许通知服务" , ancelHandler:nil)
            }
        }
    }
    var details : [String]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //计算属性 用于创建提醒实体对象
    var assignedAlarmInfo : AlarmInfo{
        get{
            var alarmInfo = AlarmInfo()
            alarmInfo.time = locationStr
            alarmInfo.isRepeat = true
            alarmInfo.on = true
            alarmInfo.sound = ""
            alarmInfo.contentTitle = locationStr
            alarmInfo.contentSubtitle = ""
            alarmInfo.contentBody = contentBody
            alarmInfo.contentBadge = 0
            alarmInfo.timeType = AlarmType.Location
            alarmInfo.showTitle = recivedValues.recivedLocation!.keys.first
            return alarmInfo
        }
    }
    
    
    var contentBody : String{
        get{
            if let content = recivedValues.recivedContent{
                return content
            }else{
                return "您收到了基于位置的提醒~"
            }
            
        }
    }
    
    var locationStr : String{
        set{
            if let alarmInfosEntiy = alarmInfosEntiy {
                let locations = alarmInfosEntiy.time?.components(separatedBy: "+")//从alarmInfo.time是由"latitude + longitude "拼接的字符串
                let latitude = Double(locations!.first!)
                let longitude = Double (locations!.last!)
                let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                recivedValues.recivedLocation = [alarmInfosEntiy.showTitle! :center]
            }
        }
        get{
            let Location = recivedValues.recivedLocation?.values.first
            let str = "\(Location!.latitude)+\(Location!.longitude)"  //强制 upward 防止出现Optional(39.91571070111064)+Optional(116.40955360471135)
            return str
        }
    }
    
    
    //lazy init
    lazy var saveBtn : UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        if self.alarmInfosEntiy != nil{
            button.setTitle("保存修改", for: .normal)
        }else{
            button.setTitle("保存", for: .normal)
        }
        
        button.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        return rightItem
    }()
    
    lazy var alarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    
    @IBOutlet weak var deleteMapBtn: UIButton!
}
