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
        
        myTextView.text = content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //回调传值
        alarmInfo.contentBody = myTextView.text
    }

    
    // MARK: - Initliazation
    
    // MARK: - DelegateMethods
    
    
    
    // MARK: - EventResponses

    
    
    
    // MARK: - PrivateMethods
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           }

    
    
    // MARK: - Properties
    
    //持有传值
    var alarmInfo : AlarmInfo!

    @IBOutlet  weak var myTextView: UITextView!
    
    
    public var content : String?
    
    
    
}
