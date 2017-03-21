//
//  WaterAddAlarmController.swift
//  WaterReminder
//
//  Created by YYang on 01/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import LTMorphingLabel
import UserNotifications
import Universal



class WaterAddAlarmController: UIViewController  {
    
    @IBOutlet weak var dateDisplayLab: LTMorphingLabel!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //懒加载导航右按钮
        self.navigationItem.rightBarButtonItem = saveBtn
        
        //申请通知权限
        NotificationUtil.requestNotificationAuthorization()
        
        dateDisplayLab.morphingEffect = LTMorphingEffect.anvil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setModifyAlarmPage()
    }
    
    
    
    private func setModifyAlarmPage()  {
        
        //检查用户通知权限 trailing closure
        UNUserNotificationCenter.current().getNotificationSettings {
            self.notificationSettings = $0
        }
        
        if let _ = alarmInfosEntiy {
            deleteBtn.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateStr = alarmInfosEntiy!.time
            timePicker.setDate(dateFormatter.date(from: dateStr!)!, animated: true)
        }
        
    }
    
    func setValue() {
        
        alarmInfo.time = dateStr!
        alarmInfo.isRepeat = true
        alarmInfo.on = true
        alarmInfo.sound = ""
        alarmInfo.contentTitle = "#该喝水了#".localized()
        alarmInfo.contentSubtitle = ""
        alarmInfo.contentBody = contentBody
        alarmInfo.contentBadge = badgeNum
        alarmInfo.timeType = AlarmType.Calendar
        alarmInfo.showTitle = dateStr!
    }
    
    private func addAlarm() -> () {
        
        
        var identifier : String?
        if alarmInfosEntiy != nil {//判断是否是修改
            identifier = alarmInfosEntiy?.identifier
        }
        
        
        //提交提醒请求
        alarmModel.sendNotification(alarmInfoEntity : alarmInfosEntiy , alarmInfo:alarmInfo , identifier : identifier , withCompletionHandler: { error in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription , in : self)
            }else{
                self.popVc()
            }
        })
    }
    
    func saveBtnClicked(){
        //1.检查用户是否设置了提醒时间
        if self.dateStr == nil {
            UIAlertController.showConfirmAlert(message: "尚未设定提醒时间!".localized(), in:  self)
            return
        }
        
        setValue()

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
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        UIAlertController.showAlert(message: "挨千刀的  确定要删除洒家吗?!", in: self, sureHandler: { (UIAlertAction) in
            self.alarmModel.removeNotification(alarmInfoEntitys : [self.alarmInfosEntiy!], fromDatabase: true)
            self.popVc()
        }, cancelHandler: nil)
    }
    
    
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dateFormatter.dateFormat = "HH:mm"
        dateStr = dateFormatter.string(from: sender.date)
        
    }
    
    
    // MARK: - 因为下部分的tableview 是 embed 到 containerView 中的 , 所以控制器和 主控制器的 数据交互通过prepare for segue的方法
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc = segue.destination
        switch destinationVc {
        case is WaterAddAlarmTableController:
            let vc  =   (destinationVc as!WaterAddAlarmTableController)
            vc.alarmInfosEntiy = alarmInfosEntiy
            vc.alarmInfo = self.alarmInfo
            
        default:
            break
        }
    }
    
    
    /// 传值属性
    var alarmInfo = AlarmInfo()
    
    
    //observing property
    var dateStr : String?{
        didSet{
            dateDisplayLab.text = "提醒时间为: ".localized() + "\(dateStr!)"
        }
    }
    
    
    
    var notificationSettings : UNNotificationSettings?{
        didSet{
            if notificationSettings?.authorizationStatus != .authorized  {
                //用户未获取到通知权限
                //  提示跳转到系统设置 通知权限
                UIAlertController.showAuthorizationAlert(msg : "您尚未允许通知权限 , 请到先进入 设置>通知> WaterRemainder 中开启 , 允许通知服务".localized() , ancelHandler: nil)
            }
        }
    }
    
    
    
    
    
    //lazy init
    lazy var saveBtn : UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 44))
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        if self.alarmInfosEntiy != nil{
            button.setTitle("保存修改".localized() , for: .normal)
        }else{
            button.setTitle("保存".localized() , for: .normal)
        }
        
        button.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        return rightItem
    }()
    
    lazy var alarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    
    
    
    
    //compute property
    var badgeNum : NSNumber{
        return NSNumber(value: targetResult-drinkResult)
    }
    
    
    var contentBody : String{
        get{
            if alarmInfo.contentBody == nil {
                return    "今日补水目标 : ".localized() + " \(targetResult)" + "ML ~~~~~~加油喝啊~~~~~一再一杯啊"
            }else{
                return "今日补水目标 : ".localized() + "\(targetResult)" + "ML ~~~~~~\(alarmInfo.contentBody!)"
            }
        }
        
    }
    
    
    
    
    
    //接受上个页面传入的提醒信息
    var alarmInfosEntiy : AlarmInfosEntiy? = nil
    
    
    var progressResult : Double{
        get{
            return CacheUtil.progressCalculatorBy(operation: .Add(0))
        }
    }
    
    var drinkResult : Double{
        get{
            return CacheUtil.readWater(type: WaterType.DrinkingWater(0))
        }
    }
    
    var targetResult : Double{
        get{
            return CacheUtil.readWater(type: WaterType.TargetWater(0))
        }
    }
    
    
}
