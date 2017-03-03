//
//  TodayViewController.swift
//  WaterReminderWidget
//
//  Created by YYang on 27/01/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import NotificationCenter
import Universal

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var waveIndicator: WaveLoadingIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(0))
    }
    
    
    @IBAction func waveIndicatorClicked(_ sender: UITapGestureRecognizer) {
        //跳转主页面
        let containerUrl = URL(string: "WidgetContainerApp://")
        self.extensionContext?.open(containerUrl!, completionHandler: { (Bool) in
        })
    }
    // 设置进度
    func configure() -> () {
        
        waveIndicator.waveAmplitude = 30
        waveIndicator.drawProgressText()
        
    }
    @IBAction func WidgetBtnClicked(_ sender: UIButton){
        let target = CacheUtil.readWater(type: WaterType.TargetWater(0))
        if target == 1{
            waveIndicatorClicked(UITapGestureRecognizer())
            return
        }
        
        
        let tag = sender.tag
        switch tag {
        case 0: 
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(200))
        case 1:
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Subtract(200))

        default:
            self.waveIndicator.progress = 0.0
            break
        }
        
    }
    
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
