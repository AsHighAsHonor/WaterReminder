//
//  WaterAddLocationContentController.swift
//  WaterReminder
//
//  Created by YYang on 28/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit

class WaterAddLocationContentController: UIViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //懒加载导航右按钮
//        self.navigationItem.rightBarButtonItem = saveBtn

        // Do any additional setup after loading the view.
        myTextView.text = content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //回调传值
        self.deliverContentClosuer!(myTextView.text)
    }

    
    // MARK: - Initliazation
    
    // MARK: - DelegateMethods
    
    
    
    // MARK: - EventResponses

    
    
    
    // MARK: - PrivateMethods
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           }

    
    
    // MARK: - Properties

    @IBOutlet  weak var myTextView: UITextView!
    
    //传值回调
    public var deliverContentClosuer : ((_ content : String)->Void)?
    
    public var content : String?
    
    
//    //lazy init
//    lazy var saveBtn : UIBarButtonItem = {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
//        button.titleLabel?.textAlignment = NSTextAlignment.right
//        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
////        if self.alarmInfosEntiy != nil{
////            button.setTitle("保存修改", for: .normal)
////        }else{
////            button.setTitle("保存", for: .normal)
////        }
//        
//        button.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
//        let rightItem = UIBarButtonItem(customView: button)
//        return rightItem
//    }()
    
}
