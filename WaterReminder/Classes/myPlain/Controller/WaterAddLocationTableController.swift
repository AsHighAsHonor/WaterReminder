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




class WaterAddLocationTableController: UITableViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //懒加载导航右按钮
        self.navigationItem.rightBarButtonItem = saveBtn
        
        //申请通知权限
        NotificationUtil.requestNotificationAuthorization()
        
        if let alarmInfosEntiy = alarmInfosEntiy {//修改模式
            deleteMapBtn.isHidden = false
            details = [alarmInfosEntiy.showTitle!,alarmInfosEntiy.body!]
            alarmInfo.contentBody = alarmInfosEntiy.body
        }else{
            details = ["请点击选择地址".localized(),"前方危险 ! 非战斗人员请撤离 ! 这不是演习 ! 这不是演习 ! 这不是演习 !".localized()]
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setModifyAlarmPage()
        
        if let body = alarmInfo.contentBody {
            self.details?[1] = body  //修改 table 对应数据源
        }
        if let showTitle  = alarmInfo.showTitle {
            self.details?[0] = showTitle  //修改 table 对应数据源
        }
        

    }
    
    
    // MARK: - DelegateMethods
    // MARK: Table view data source
    
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
            cell?.textLabel?.text = "地址:".localized()
        case 1:
            cell?.textLabel?.text = "内容:".localized()
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
    
    
    
    
    
    // MARK: - EventResponses
    
    @IBAction func deleteMapBtnClicked(_ sender: UIButton) {
        UIAlertController.showAlert(message: "挨千刀的  确定要删除洒家吗?!".localized(), in: self, sureHandler: { (UIAlertAction) in
            self.alarmModel.removeNotification(alarmInfoEntitys : [self.alarmInfosEntiy!], fromDatabase: true)
           self.popVc()
        }, cancelHandler: nil)

    }
    
    func saveBtnClicked()  {
        //1.检查是否选择了位置
        guard (alarmInfo.time != nil) else {
            toast(msg : "请先选择地址!".localized())
            return
        }
        
        //2.检查提醒内容
        if alarmInfo.contentBody == nil  {
            alarmInfo.contentBody = details?[1]
        }
        
        //3.检查通知权限
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
        
        var identifier : String? //围栏通知触发需要设置notification / regionMonitor 的 identifier 相同
        if alarmInfosEntiy != nil {//判断是否是修改
            identifier = alarmInfosEntiy?.identifier
        }else{
            identifier = UUID().uuidString
        }
        
        
        //提交提醒请求
        //1.添加一个UNLocationNotificationTrigger 2.添加一个区域检测 3.确保 1.2的identifier相同
        alarmModel.sendNotification(alarmInfoEntity : alarmInfosEntiy , alarmInfo: alarmInfo, identifier : identifier , withCompletionHandler: {[unowned self] error in
            if let error = error {
                self.toast(msg: error.localizedDescription )
            }else{
                //TODO: 添加一个区域监听
//                let Location = self.recivedValues.recivedLocation?.values.first
//                let region = CLCircularRegion(center: Location!, radius: 10, identifier: identifier!)
//                region.notifyOnEntry = true
//                region.notifyOnExit = true
//                self.locationUtil.startMonitoring(region: region)
                //pop
                self.popVc()
            }
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination
        
        switch destinationVc {
        case is WaterAddLocationContentController:
            let vc  =   (destinationVc as!WaterAddLocationContentController)
            vc.alarmInfo = self.alarmInfo//传值对象
            if let alarmInfosEntiy = alarmInfosEntiy { //修改模式
                vc.content = alarmInfosEntiy.body!
            }
           

        case is WaterAddLocationMapController:
            let vc : WaterAddLocationMapController =  (destinationVc as! WaterAddLocationMapController)
            vc.alarmInfo = self.alarmInfo//传值对象
            vc.alarmInfosEntiy = self.alarmInfosEntiy//修改模式

        default:
            break
        }
    }
    
    // MARK: - Properties
    
    //接受上个页面传入的提醒信息
    var alarmInfosEntiy : AlarmInfosEntiy? = nil
    
    /// 传值属性
    var alarmInfo = AlarmInfo()
    
    var notificationSettings : UNNotificationSettings?{
        didSet{
            if notificationSettings?.authorizationStatus != .authorized  {
                //用户未获取到通知权限
                //  提示跳转到系统设置 通知权限
                UIAlertController.showAuthorizationAlert(msg : "您尚未允许通知权限 , 请到先进入 设置>通知> WaterRemainder 中开启 , 允许通知服务".localized() , ancelHandler:nil)
            }
        }
    }
    var details : [String]?{
        didSet{
            self.tableView.reloadData()
        }
    }

    
    
    //lazy init
    lazy var saveBtn : UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 44))
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        if self.alarmInfosEntiy != nil{
            button.setTitle("保存修改".localized(), for: .normal)
        }else{
            button.setTitle("保存".localized(), for: .normal)
        }
        
        button.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        return rightItem
    }()
    
    lazy var alarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    
    private let locationUtil = LocationUtil()

    
    @IBOutlet weak var deleteMapBtn: UIButton!
}
