//
//  BaseViewController.swift
//  WaterReminder
//
//  Created by YYang on 15/02/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    func showHud(msg : String) -> () {
        hud.textLabel.text = msg
        hud.show(in:UIApplication.shared.keyWindow?.rootViewController?.view, animated: true)
        
    }
    
    func hideHud() -> () {
        if hud.isVisible{
            hud.dismiss()
        }
    }
    
    lazy var hud : JGProgressHUD = {
        return  JGProgressHUD(style: JGProgressHUDStyle.dark)
    }()


}
