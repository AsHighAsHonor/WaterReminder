//
//  WaterPlanTableViewController.swift
//  WaterReminder
//
//  Created by YYang on 25/01/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import  Universal



class WaterPlanTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registeCell(WaterPlanControlCell.self ,isClass : false)
        self.tableView.registeCell(WaterPlanSetCell.self , isClass : false)
        
        self.navigationItem.rightBarButtonItem = addBtn
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //查询所有等待激活的通知
        waterAlarmModel.getPendingNotificationRequest()
        //从数据库查询全部
        alarmInfosEntiys = waterAlarmModel.searchAlarmInfosFromDatabase(identifier: nil)
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return setInfos.count
        }else{
            return (alarmInfosEntiys?.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            return
        }
        //        (addVc as! WaterAddAlarmController).alarmInfosEntiy = alarmInfosEntiys?[indexPath.row]

        let type = alarmInfosEntiys?[indexPath.row].timeType
        switch  type!{
        case AlarmType.Calendar.rawValue:
            performSegue(withIdentifier: SegueId.AddCalendarSegue.rawValue, sender: alarmInfosEntiys?[indexPath.row])
        case AlarmType.Location.rawValue:
            performSegue(withIdentifier: SegueId.AddLocationSegue.rawValue, sender: alarmInfosEntiys?[indexPath.row])
        default:
            break
        }
        

    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell : WaterPlanSetCell = tableView.dequeue(IndexPath: indexPath)
            cell.setLabel.text = setInfos[indexPath.row][setLabKey] as! String?
            cell.toggle.setOn((setInfos[indexPath.row][toggleStateKey]as! Bool), animated: true)
            configureCell(indexPath: indexPath, cell: cell)
            return cell
            
        }else{
            let cell : WaterPlanControlCell  = tableView.dequeue(IndexPath: indexPath)
            cell.timeLab.text = alarmInfosEntiys?[indexPath.row].showTitle!
            cell.timeTypeLab.text = alarmInfosEntiys?[indexPath.row].timeType!
            cell.toggle.isOn = (alarmInfosEntiys?[indexPath.row].isOn)!
            //设置 cell 上 switch 的开关的回调
            configureCell(indexPath: indexPath, cell: cell)
            return cell
        }
    }
    
    func configureCell(indexPath : IndexPath , cell : UITableViewCell) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                break;
            }
            
            //禁用/启用所有通知
            //开关的回调
            let cell = cell as!WaterPlanSetCell
            cell.toggleChangeClouser = {
                [unowned self] (isOn : Bool ) in
                //1.缓存当前设置到 userdefault
                _ = CacheUtil.userSettingOperation(toggle: isOn, setting: .AlarmToggle)
                //2.禁用/启用所有通知
                self.waterAlarmModel.alarmSwitch(toggle: isOn, alarmInfoEntitys: self.alarmInfosEntiys!, completeHandler: {
                    //完成后刷新 section =1的部分
                    if let  infos = self.waterAlarmModel.searchAlarmInfosFromDatabase(identifier: nil) {
                        self.alarmInfosEntiys = infos
                    }
                })
            }
        case 1://每个提醒单独的开关设置
            let cell = cell as!WaterPlanControlCell
            cell.toggleChangeClouser = {
                [unowned self] (isOn : Bool ) in
                //1.禁用/启用 通知
                self.waterAlarmModel.alarmSwitch(toggle: isOn, alarmInfoEntitys:[ self.alarmInfosEntiys![indexPath.row]], completeHandler: {
                    //完成后刷新 section =1的部分
                    if let  infos = self.waterAlarmModel.searchAlarmInfosFromDatabase(identifier: nil) {
                        self.alarmInfosEntiys = infos
                    }
                })
            }
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination
        if let sender = sender {
            destinationVc.setValue(sender as!AlarmInfosEntiy , forKey: "alarmInfosEntiy")
        }
    }
    
    
    func navRightBtnClicked() -> () {
        let alert = UIAlertController(title: "请选择".localized(), message: "想要添加的提醒类型".localized(), preferredStyle: .actionSheet)
        let calendarAct = UIAlertAction(title: "定時提醒".localized(), style: .default) {[unowned self]  (act) in
           self.performSegue(withIdentifier: SegueId.AddCalendarSegue.rawValue, sender: nil)
        }
        
        let loactionAct = UIAlertAction(title: "定位提醒(测试中...)".localized(), style: .default) { (act) in
            self.performSegue(withIdentifier: SegueId.AddLocationSegue.rawValue, sender: nil)
        }
        
        _ = UIAlertAction(title: "倒计时提醒".localized() , style: .default) { (act) in
            
        }
        
        alert.addAction(calendarAct)
        alert.addAction(loactionAct)
//        alert.addAction(intervalAct)
        alert.addAction(UIAlertAction(title: "取消".localized(), style: .destructive){(act) in})
        self.present(alert, animated: true)
    }
    
    var setInfos  = [
        ["setLab" : "开启所有提醒".localized() ,"toggle" :CacheUtil.userSettingOperation(toggle: nil, setting: .AlarmToggle) ?? false ],
        //        ["setLab" : "点击此处删除所有提醒" ,"toggle" : false ],
        //        ["setLab" : "目标完成后关闭当日提醒" ,"toggle" :false ],
    ]
    
    
    let toggleStateKey = "toggle"
    let setLabKey = "setLab"
    
    ///数据库读取数据有变动刷新列表
    var alarmInfosEntiys : [AlarmInfosEntiy]?{
        didSet{
            self.tableView.reloadSections( IndexSet(integer: 1), with: UITableViewRowAnimation.left)
            
            //数据库中没有保存的通知 移除所有待触发的PendingNotificationRequests
            if alarmInfosEntiys == nil || alarmInfosEntiys?.count == 0 {
                waterAlarmModel.removeNotification(alarmInfoEntitys: nil, fromDatabase: true)
            }
        }
    }
    
    lazy var waterAlarmModel : WaterAlarmModel = {
        return WaterAlarmModel()
    }()
    
    //lazy init
    lazy var addBtn : UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitle("添加".localized() , for: .normal)
        button.addTarget(self, action: #selector(navRightBtnClicked), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        return rightItem
    }()
    
}
