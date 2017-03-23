//
//  WaterAddAlarmTableController.swift
//  WaterReminder
//
//  Created by YYang on 02/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit

class WaterAddAlarmTableController: UITableViewController {
    
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let alarmInfosEntiy = alarmInfosEntiy {
            details = [alarmInfosEntiy.body]
        }else{
            details = ["你该喝水了!".localized()]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let content  = alarmInfo.contentBody {
            details?[0] = content
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  details!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reid =  String(describing: UITableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier:reid)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reid)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.detailTextLabel?.text = details?[indexPath.row]

        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "提醒内容:".localized()
        default:
            break
        }

        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0://跳转设置提示语
            performSegue(withIdentifier: SegueId.AddCalendarContentSegue.rawValue, sender: nil)
        default:
            break
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination
        
        switch destinationVc {
        case is WaterAddLocationContentController:
            let vc  =   (destinationVc as!WaterAddLocationContentController)
            vc.alarmInfo = self.alarmInfo
            if let alarmInfosEntiy = alarmInfosEntiy { //修改进入
                vc.content = alarmInfosEntiy.body
            }
            
        default:
            break
        }
    }

    
    
    var details : [String]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //根据是否有 AlarmInfosEntiy 来判断是否是修改模式
    var alarmInfosEntiy : AlarmInfosEntiy?
    
    //持有传值
    var alarmInfo : AlarmInfo!
    
    
}
