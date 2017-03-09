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



/// 3Dtouch进入app 后跳转的页面
///
/// - QrScan: 二维码扫描
enum QuickActionType : String{
    case QrScan
}

class WaterMainController: BaseViewController {
    
    
    @IBOutlet weak var animationLab: LTMorphingLabel!
    
    @IBOutlet weak var waveIndicator: WaveLoadingIndicator!
    
    var quickActStr : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配置动态 label
        configure()
        //更新天气
        fetchWeaterData()
        //添加通知观察者更新界面  防止水量不自动清零
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: AppDelegate.updateUIName), object: nil)
        self.view.addSubview(spreadBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //检查版本更新
        updateVersion()
        updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppDelegate.updateUIName), object: nil)
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
    
    
    func updateUI()  {
        let progress =  progressResult
        if progress != 0 {
            waveIndicator.progress = progress
        }else{
            waveIndicator.progress = 0
        }
    

    }
    
    //MARK: 获取天气1
    func fetchWeaterData()  {
        cargador.requestLoacteAuthorizationAndFetchWeaterData { (weather) in
            self.weatherCompleted(response: weather)
        }
    }
    //MARK: 获取天气2
    func weatherCompleted(response : DataResponse<Any>) {
        switch response.result {
        case .success(let value):
            let weatherModel = WaterWeatherRootClass(fromJson: JSON(value))
            let temperature = cargador.temperatureTransfer(Fahrenheit: Double(weatherModel.query.results.channel.item.condition.temp!)!)
            let tempStr = "国家: \(weatherModel.query.results.channel.location.country!) \n 城市:\(weatherModel.query.results.channel.location.city!) \n 日出:\(weatherModel.query.results.channel.astronomy.sunrise!) \n 日落:\(weatherModel.query.results.channel.astronomy.sunset!) \n 气温:\(temperature) ℃ \n  描述: \(weatherModel.query.results.channel.item.condition.text!) \n 更新时间: \(weatherModel.query.results.channel.item.condition.date!) \n"
            self.temperature = tempStr
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: 版本更新1
    func updateVersion() -> () {
        let urlStr = "http://api.fir.im/apps/latest/589d9d7e959d6944d80000e6?api_token=2bc11ca72f6af8f858cf648342d6693b"
        let _=Alamofire.request(urlStr).responseJSON { (resopnse) in
            self.updateCompleted(response: resopnse)
        }
        
    }
    // MARK: 版本更新1
    func updateCompleted(response : DataResponse<Any>){
        //        self.hideToast()
        switch response.result {
        case .success(let value):
            let versionModel = WaterVersionInfoModel(fromJson: JSON(value))
            
            if let updateUrl = URL(string : versionModel.updateUrl),
                let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String   //info 中取出的 version 是 any 类型 要先转换成 string
            {
                print("response=======>>>>" + String(describing: JSON(value)))
                
                if version != versionModel.version && UIApplication.shared.canOpenURL(updateUrl){
                    UIAlertController.showAlert(message: "发现新版本,请更新\(versionModel.changelog!)", in: self, sureHandler: { (UIAlertAction) in
                        //更新
                        UIApplication.shared.open(updateUrl, options: [:], completionHandler: { (Bool) in
                        })
                    }, cancelHandler: nil)
                }
            }
            
        case .failure(let error):
            print(error.localizedDescription)
            //            self.toast(msg: error.localizedDescription)
        }
        
    }
    
    
    
    
    func configure() {
        
        animationLab.text = "今日补水目标 : \(targetResult) 毫升"
        animationLab.morphingEffect = LTMorphingEffect.fall
        waveIndicator.waveAmplitude = 45
        waveIndicator.drawProgressText()
        
        // TODO: 配置主题颜色
        //        self.ch.refreshBlock = { [weak self](now: Any, pre: Any?) -> Void in
        //            if let now = ChameleonHelper<String>.parse(now) {
        //                self?.waveIndicator.heavyColor = UIColor.colorWithHexString(now)
        //            }
        //
        //        }
        
    }
    
    
    @IBAction func AnimationLabTap(_ sender: UITapGestureRecognizer) {
        if animationLab.text.contains("当前") {
            observeTargetResult = targetResult
        }else{
            observeDrinkingResult = drinkResult
        }
    }
    
    func showAlert() -> () {
        let alertVc = UIAlertController(title: "设置水量", message: "请输入今日的目标补水量", preferredStyle: UIAlertControllerStyle.alert)
        let act1 = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let text = alertVc.textFields?.first?.text
            if  (text != nil) && !(text?.isEmpty)! && CacheUtil.waterChecker(water: Double(text!)!){
                //用户已输入
                print(text!)
                CacheUtil.saveWaterBy(waterType: WaterType.TargetWater(Double(text!)!))
                self.observeTargetResult = self.targetResult
            }else{
                print("请输入水量")
            }
        }
        let act2 = UIAlertAction(title: "取消", style:  UIAlertActionStyle.cancel) { (UIAlertAction) in
            print("取消")
        }
        
        alertVc.addAction(act1)
        alertVc.addAction(act2)
        alertVc.addTextField { (textField) in
            textField.placeholder = "水量单位 : 毫升"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        self.present(alertVc, animated: true) {
        }
        
    }
    
    func pushQrScan() {
        let vc = WaterScanViewController();
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    lazy var spreadBtn : ZYSpreadButton = {
        
        let backImg = ZYSpreadSubButton.image(with: UIColor(red: 0.4376174212, green: 0.7448593974, blue: 0.9861226678, alpha: 1))
        
        
        let btn2 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "drinkmore"), highlight: #imageLiteral(resourceName: "drinkmore"), andTitle: "", clickedBlock: { (index, sender) in
            self.showAlert()
        })
        
        let btn3 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "cup2"), highlight: #imageLiteral(resourceName: "cup2"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(300))
            self.observeDrinkingResult = self.drinkResult
            //            UIApplication.ch.refresh(with: "#FFE1C5") //TODO: 切换主题颜色
            
        })
        
        
        
        
        let btn4 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "cup1"), highlight: #imageLiteral(resourceName: "cup1"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(200))
            self.observeDrinkingResult = self.drinkResult
        })
        
        
        let btn5 = ZYSpreadSubButton(backgroundImage: #imageLiteral(resourceName: "drop"), highlight: #imageLiteral(resourceName: "drop"), andTitle: "", clickedBlock: { (index, sender) in
            self.waveIndicator.progress = CacheUtil.progressCalculatorBy(operation: .Add(100))
            self.observeDrinkingResult = self.drinkResult
        })
        
        let zySpreadButton = ZYSpreadButton(backgroundImage: UIImage(named: "powerButton"), highlight: UIImage(named: "powerButton_highlight"), position: CGPoint(x:UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height - 90))
        
        guard let button2 = btn2, let button3 = btn3 ,let button4 = btn4 ,let button5 = btn5 else {
            return zySpreadButton!
        }
        zySpreadButton?.subButtons = [ button2, button3 ,button4 , button5]
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
                title = "扫一扫"
            case 1:
                image = #imageLiteral(resourceName: "contacts_add_newmessage")
                title = "别点会炸"
            case 2:
                image = #imageLiteral(resourceName: "contacts_add_friend")
                title = "别点会炸!"
            case 3:
                image = #imageLiteral(resourceName: "contacts_add_mycard")
                title = "别点会炸!!"
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
    
    
    
    /// 天气工具
    lazy var cargador : WeatherCargador = {
        return WeatherCargador()
    }()
    
    weak var popMenu: LXFPopMenu?
    
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
            let target = CacheUtil.readWater(type: WaterType.TargetWater(0))
            if target == 1 {
                UIAlertController.showAlert(message: "是否使用为您推荐的2000毫升补水目标?", in: self, sureHandler: { (UIAlertAction) in
                    self.sureClicked(action: UIAlertAction) //点击确定使用目标水量
                }, cancelHandler: { (UIAlertAction) in
                    self.cancelClicked(action: UIAlertAction)//点击取消不使用目标水量  弹出设置水量
                })
            }
            
            return CacheUtil.readWater(type: WaterType.TargetWater(0))
        }
        
    }
    
    private func sureClicked(action : UIAlertAction) {
        CacheUtil.saveWaterBy(waterType: WaterType.TargetWater(2000))
        self.observeTargetResult = self.targetResult
    }
    
    private func cancelClicked(action : UIAlertAction) {
        self.showAlert()
    }
    
    
    var observeTargetResult : Double?{
        didSet{
            animationLab.text = "今日补水目标 : \(targetResult) 毫升"
        }
    }
    
    var observeDrinkingResult : Double?{
        didSet{
            animationLab.text = "当前补水量 : \(drinkResult) 毫升"
        }
    }
    
    var temperature : String?{
        didSet{
            weatherLabel.text = temperature
        }
    }
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    
}

