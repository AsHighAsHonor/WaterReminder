//
//  WaterMainController.swift
//  WaterReminder
//
//  Created by YYang on 24/01/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import Universal
import LTMorphingLabel
import Alamofire
import SwiftyJSON
import JGProgressHUD
import swiftScan
import Localize_Swift



/// 3Dtouch进入app 后跳转的页面
///
/// - QrScan: 二维码扫描
enum QuickActionType : String{
    case QrScan
}


class WaterMainController: BaseViewController {
    
    var quickActStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配置动态 label
        configure()
        self.view.addSubview(spreadBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //检查版本更新
        updateVersion()
        updateUI()
        //更新天气
        fetchWeaterData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 隐藏菜单
        popMenu?.dismissPopMenuAnimatedOnMenu(selected: false)
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        YYPrint("touches======>>>>>>\(touches) \n event======>>>> \(String(describing: event))")
        //1.是否水量模式
        guard settingMode else {return}
        guard let touch = touches.first else {return}
        //2.是否支持3d touch
        guard  TouchUtil.sharedInstance.fourceTouchCapability(controller: self) else {return}
        //3.是否是settingImageView在响应事件
        guard touch.view === settingImageView else {return}
        
        if touch.force >= touch.maximumPossibleForce{
            //超出3000ml
            self.waveIndicator.progress = 1
            self.waveIndicator.content = String(WaterMainController.DefaultTarget) + "毫升".localized()
        } else {
            let force = touch.force/touch.maximumPossibleForce
            self.waveIndicator.progress = Double(force)
            self.waveIndicator.content = String("\(force * CGFloat(WaterMainController.DefaultTarget))") + "毫升".localized()
        }

    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        YYPrint("++++++++++++touchesBegan+++++++++++ \n touches======>>>>>>\(touches) \n event======>>>> \(String(describing: event))")
//
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        YYPrint("++++++++++++touchesEnded+++++++++++ \n touches======>>>>>>\(touches) \n event======>>>> \(String(describing: event))")
//
//    }
//    
//    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
//        YYPrint("++++++++++++touchesEnded+++++++++++ \n touches======>>>>>>\(touches)")
//    }
    
    func configure() {
        animationLab.text = "今日补水目标 : ".localized() + "\(targetResult)"+"毫升".localized()
        animationLab.morphingEffect = LTMorphingEffect.fall
        waveIndicator.waveAmplitude = 45
        waveIndicator.isPercentage = false
        waveIndicator.drawProgressText()
        
    }
    
    
    // MARK: - Properties
    
    ///默认最大水量
    fileprivate static let DefaultTarget = 3000.0

    lazy var spreadBtn : ZYSpreadButton = {
        
        let backImg = ZYSpreadSubButton.image(with: UIColor(red: 0.4376174212, green: 0.7448593974, blue: 0.9861226678, alpha: 1))
        
//        let btn2 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "drinkmore"), highlight: #imageLiteral(resourceName: "drinkmore"), andTitle: "", clickedBlock: { (index, sender) in
//        })
        
        let btn3 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "cup2"), highlight: #imageLiteral(resourceName: "cup2"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(300))
           self.waveIndicator.content = String(self.drinkResult) + "毫升".localized()
            self.observeDrinkingResult = self.drinkResult
            
        })
        
        let btn4 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "cup1"), highlight: #imageLiteral(resourceName: "cup1"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(200))
            self.waveIndicator.content = String(self.drinkResult) + "毫升".localized()
            self.observeDrinkingResult = self.drinkResult
        })
        
        
        let btn5 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "drop"), highlight: #imageLiteral(resourceName: "drop"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(100))
            self.waveIndicator.content = String(self.drinkResult) + "毫升".localized()
            self.observeDrinkingResult = self.drinkResult
        })
        
        let zySpreadButton = ZYSpreadButton(backgroundImage: UIImage(named: "powerButton"), highlight: UIImage(named: "powerButton_highlight"), position: CGPoint(x:UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height - 90))
        
        guard let button3 = btn3 ,let button4 = btn4 ,let button5 = btn5 else {
            return zySpreadButton!
        }
        zySpreadButton?.subButtons = [ button3 ,button4 , button5]
        zySpreadButton?.mode = SpreadModeFlowerSpread
        zySpreadButton?.direction = SpreadDirectionTop
        zySpreadButton?.radius = 120
        zySpreadButton?.positionMode = SpreadPositionModeTouchBorder
        zySpreadButton?.coverAlpha = 0.8
        zySpreadButton?.buttonWillSpreadBlock = { print($0?.frame.maxY ?? 0) }
        zySpreadButton?.buttonDidSpreadBlock = { _ in print("did spread") }
        zySpreadButton?.buttonWillCloseBlock = { _ in print("will closed") }
        zySpreadButton?.buttonDidCloseBlock = { _ in print("did closed") }
        return zySpreadButton!
    }()
    
    var settingMode : Bool = false{
        didSet{
            if settingMode == true{
                
                settingImageView.isHidden = true
                settingSilder.value = Float(targetResult/WaterMainController.DefaultTarget)
// TODO: 压力感应设置水量
//                //支持3dtouch 的显示指纹 view
//                if TouchUtil.sharedInstance.fourceTouchCapability(controller: self){
//                    settingSilder.isHidden = true
//                    settingTipsLabel.text = "轻按上方指纹处设置今日补水目标".localized()
//                }else{
//                    settingImageView.isHidden = true
//                }
                

            } else{
                //1.保存当前水量
                self.observeTargetResult = self.targetResult
                //更新当前 wave 水量
                updateUI()
            }
            
        }
    }
    
    ///显示水量的动画label
    @IBOutlet weak var animationLab: LTMorphingLabel!
    
    ///显示水量的动画waveIndicator
    @IBOutlet weak var waveIndicator: WaveLoadingIndicator!

    /// 天气工具
    lazy var cargador : WeatherCargador = {
        return WeatherCargador()
    }()
    
    ///右上角popover
    weak var popMenu: LXFPopMenu?
    
    var progressResult : Double{
        get{
            return CacheUtil.progressCalculatorBy(operation: .Add(0))
        }
    }
    
    
    /// 获取已喝水量
    var drinkResult : Double{
        get{
            return CacheUtil.readWater(type: WaterType.DrinkingWater(0))
        }
    }
    
    /// 获取目标水量
    var targetResult : Double{
        get{
            let target = CacheUtil.readWater(type: WaterType.TargetWater(0))
            if target == 1 {
                UIAlertController.showAlert(message: "是否使用为您推荐的2000毫升补水目标?".localized() , in: self, sureHandler: { (UIAlertAction) in
                    self.sureClicked(action: UIAlertAction) //点击确定使用目标水量
                }, cancelHandler: { (UIAlertAction) in
                    self.cancelClicked(action: UIAlertAction)//点击取消不使用目标水量  弹出设置水量
                })
            }
            return target
        }
        
    }
    
    /// 观察目标水量更新ui
    var observeTargetResult : Double?{
        didSet{
            animationLab.text = "今日补水目标 : ".localized() + "\(targetResult)" + "毫升".localized()
        }
    }
    /// 观察已喝水量更新ui
    var observeDrinkingResult : Double?{
        didSet{
            animationLab.text = "当前补水量 : ".localized() + "\(drinkResult)" + "毫升".localized()
        }
    }
    
    /// 观察天气更新 ui
    var temperature : String?{
        didSet{
            weatherLabel.text = temperature
        }
    }
    
    var weatherModel : WaterWeatherRootClass!
    
    
    /// 获取天气 model
    var temperatureModel : WaterWeatherRootClass{
        get{
            return self.temperatureModel
        }
        set{
            let temperature = cargador.temperatureTransfer(Fahrenheit: Float(weatherModel.query.results.channel.item.condition.temp!)!)
            let country = weatherModel.query.results.channel.location.country!
            let city = weatherModel.query.results.channel.location.city!
            let sunRise = weatherModel.query.results.channel.astronomy.sunrise!
            let sunSet = weatherModel.query.results.channel.astronomy.sunset!
            let description = weatherModel.query.results.channel.item.condition.text!
            let updateTime = weatherModel.query.results.channel.item.condition.date!
            let tempStr = "国家: ".localized() + "\(country) \n" + "城市: ".localized() + "\(city) \n " + "日出: ".localized() + "\(sunRise) \n" + "日落: ".localized()  + "\(sunSet) \n" + "气温: ".localized() + "\(temperature) ℃ \n " + "描述: ".localized() + "\(description) \n " + "更新时间: ".localized() + "\(updateTime) \n"
            self.temperature = tempStr
        }
    }


    
    ///  设置水量下方提示label
    @IBOutlet weak var settingTipsLabel: UILabel!
    
    /// 展示天气的 label
    @IBOutlet weak var weatherLabel: UILabel!
    
    ///view2上设置水量的silder
    @IBOutlet weak var settingSilder: UISlider!
    
    ///view2上设置水量的指纹image
    @IBOutlet weak var settingImageView: UIImageView!
    
    ///控制底部天气所在 view 的约束
    @IBOutlet weak var view1TrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view1LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view2LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view2TrailingConstraint: NSLayoutConstraint!
    
    ///控制底部天气所在 view 的动画
    var view1TrailingPriority : UILayoutPriority?{
        didSet{
            if view1TrailingConstraint.priority == UILayoutPriorityDefaultHigh {
                view1TrailingConstraint.priority  = UILayoutPriorityDefaultLow
                view1LeadingConstraint.priority = UILayoutPriorityDefaultLow
                view2LeadingConstraint.priority = UILayoutPriorityDefaultHigh
                view2TrailingConstraint.priority = UILayoutPriorityDefaultHigh
            }else{
                view1TrailingConstraint.priority  = UILayoutPriorityDefaultHigh
                view1LeadingConstraint.priority = UILayoutPriorityDefaultHigh
                view2TrailingConstraint.priority = UILayoutPriorityDefaultLow
                view2LeadingConstraint.priority = UILayoutPriorityDefaultLow
            }
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        }
    }
   }




// MARK: - EventResponses
extension WaterMainController{
    
    //silderBar值改变
    @IBAction func sliderBarValueDidChanged(_ sender: AnyObject) {
        let value = lroundf(settingSilder.value * Float(WaterMainController.DefaultTarget))
        waveIndicator.content = String(value) + "毫升".localized()
        waveIndicator.progress = Double(settingSilder.value)
        CacheUtil.saveWaterBy(waterType: WaterType.TargetWater(Double(value)))
    }
    
    ///切换水量设置模式
    @IBAction func indicatorPressed(_ sender: Any) {
        view1TrailingPriority = UILayoutPriorityDefaultLow
        settingMode = !settingMode
    }
    
    fileprivate func sureClicked(action : UIAlertAction) {
        CacheUtil.saveWaterBy(waterType: WaterType.TargetWater(2000))
        self.observeTargetResult = self.targetResult
    }
    
    fileprivate func cancelClicked(action : UIAlertAction) {
        //点击取消进入设置界面
        indicatorPressed(action)
    }

    
    @IBAction func popoverBtnClicked(_ sender: UIBarButtonItem) {
        popMenu(UIButton())
    }
    
    
    func popMenu(_ sender: UIButton) {
        var popMenuItems: [LXFPopMenuItem] = [LXFPopMenuItem]()
        for i in 0..<4 {
            var image: UIImage!
            var title: String!
            switch i {
            case 0:
                image = #imageLiteral(resourceName: "contacts_add_scan")
                title = "扫一扫".localized()
            case 1:
                image = #imageLiteral(resourceName: "contacts_add_newmessage")
                title = "别点会炸".localized()
            case 2:
                image = #imageLiteral(resourceName: "contacts_add_friend")
                title = "别点会炸!".localized()
            case 3:
                image = #imageLiteral(resourceName: "contacts_add_mycard")
                title = "别点会炸!!".localized()
            default: break
            }
            let popMenuItem = LXFPopMenuItem(image: image, title: title)
            popMenuItems.append(popMenuItem)
        }
        self.popMenu = LXFPopMenu(menus: popMenuItems)
        // 弹出菜单
        popMenu?.showMenu(on: self.view, at: CGPoint.zero)
        popMenu?.popMenuDidSelectedBlock = { (index, menuItem) in
            YYPrint("\(index), \(menuItem)")
            switch index {
            case 0:
                // 二维码扫描入口
                self.pushQrScan()
            default:
                break
            }
        }
    }
    
    
    @IBAction func AnimationLabTap(_ sender: UITapGestureRecognizer) {
        if animationLab.text.contains("当前".localized()) {
            observeTargetResult = targetResult
        }else{
            observeDrinkingResult = drinkResult
        }
    }
    
    
    func pushQrScan() {
        let vc = WaterScanViewController();
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

// MARK: - PrivateMethods
extension WaterMainController{
    func updateUI()  {
        let progress =  progressResult
        self.waveIndicator.content = String(self.drinkResult) + "毫升".localized()
        if progress != 0 {
            waveIndicator.progress = progress
        }else{
            waveIndicator.progress = 0
        }
    }
    
    //MARK: 获取天气
    func fetchWeaterData()  {
        guard weatherLabel.text == "Weather Loading" else {
            return
        }
        
        cargador.requestLoacteAuthorizationAndFetchWeaterData {[unowned self] (weather) in
            self.weatherCompleted(response: weather)
        }
    }
    func weatherCompleted(response : DataResponse<Any>) {
        switch response.result {
        case .success(let value):
            self.weatherModel = WaterWeatherRootClass(fromJson: JSON(value))
            self.temperatureModel =  self.weatherModel
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: 版本更新
    func updateVersion() -> () {
        let urlStr = "http://api.fir.im/apps/latest/589d9d7e959d6944d80000e6?api_token=2bc11ca72f6af8f858cf648342d6693b"
        let _=Alamofire.request(urlStr).responseJSON { (resopnse) in
            self.updateCompleted(response: resopnse)
        }
        
    }
    func updateCompleted(response : DataResponse<Any>){
        switch response.result {
        case .success(let value):
            let versionModel = WaterVersionInfoModel(fromJson: JSON(value))
            
            if let updateUrl = URL(string : versionModel.updateUrl),
                let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String   //info 中取出的 version 是 any 类型 要先转换成 string
            {
                print("response=======>>>>" + String(describing: JSON(value)))
                
                if version != versionModel.version && UIApplication.shared.canOpenURL(updateUrl){
                    
                    let updateStr = "发现新版本,请更新 ".localized() + "\(versionModel.changelog!)"
                    UIAlertController.showAlert(message: updateStr, in: self, sureHandler: { (UIAlertAction) in
                        //更新
                        UIApplication.shared.open(updateUrl, options: [:], completionHandler: { (Bool) in
                        })
                    }, cancelHandler: nil)
                }
            }
            
        case .failure(let error):
            print(error.localizedDescription)
        }
        
    }

}

// MARK: - DelegateMethods
extension WaterMainController{
    
}

// MARK: - Navigation
extension WaterMainController{
    
}




