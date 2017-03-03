//
//  WaterAddAlarmItemController.swift
//  WaterReminder
//
//  Created by YYang on 08/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit


class WaterAddAlarmItemController: UITableViewController , UITextFieldDelegate{
    public var timeTypeClosuer : ((_ timeType : AlarmType)->())?  //选中cell后的回调
    public var alarmContentClosuer : ((_ content : String)->Void)?//提醒内容输入完成后的回调
    
     // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alarmInfosEntiy = alarmInfosEntiy {
            self.alarmContentTextField.text = alarmInfosEntiy.body
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return setItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = setItems[indexPath.row][labTitle] as! String?
            
            if let alarmInfosEntiy = alarmInfosEntiy {
                //修改模式  已有提醒  获取保存的提醒实体中的提醒信息
                if (setItems[indexPath.row][labTitle] as! String) == alarmInfosEntiy.timeType {
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }else{
                //新加提醒
                if (setItems[indexPath.row][acceossory] as! Bool) {
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            
            
        default:
            break
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            
            if let alarmInfosEntiy = alarmInfosEntiy {
                //修改模式  只需要改变alarmInfosEntiy 的 timeType  然后 reload
                alarmInfosEntiy.timeType =  tableView.cellForRow(at: indexPath)?.textLabel?.text
                
            }else{
                //新加模式
                //将选中的 cell 对应的数据源acceossory 置为 !  其余置为 false  然后 reload
                for (idx,_) in setItems.enumerated() {
                    if idx == indexPath.row {//修改对应选中数据
                        setItems[idx][acceossory] = !(setItems[idx][acceossory] as! Bool)
                    }else{
                        setItems[idx][acceossory] = false
                    }
                }
            }
           
            self.tableView.reloadSections( IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)

            //回调传值给主控制器
            timeTypeClosuer!(timeType(indexPath: indexPath))
            
        default:
            break
        }

    }
    
     // MARK: - textField delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let content = textField.text  else {
            return
        }
        if content.isEmpty {
            return
        }
        //回调传值给主控制器
        alarmContentClosuer!(content)
    }
    
    
    
    
    func timeType(indexPath : IndexPath) -> AlarmType {
        var type : AlarmType?
        switch setItems[indexPath.row][labTitle] as! String {
        case "时间":
            type = .Calendar
        case "地理位置":
            type = .Location
        case "倒计时":
            type = .Interval
        default:
            break
        }
        return type!
    }


    
    let labTitle = "labTitle"
    let acceossory = "acceossory"
    
    //根据是否有 AlarmInfosEntiy 来判断是否是修改模式
    var alarmInfosEntiy : AlarmInfosEntiy?
    
    var setItems : [Dictionary<String , Any>] = [
        ["labTitle" : "每日提醒","acceossory" : false],
        ["labTitle" : "工作日提醒","acceossory" : false],
        ["labTitle" : "周末提醒","acceossory" : false],
        ]


    @IBOutlet weak var alarmContentTextField: UITextField!
    

}
