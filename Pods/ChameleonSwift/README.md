
# ChameleonSwift


[![Language: Swift 3](https://img.shields.io/badge/language-Swift%203-f48041.svg?style=flat)](https://developer.apple.com/swift)
![Platform: iOS 8+](https://img.shields.io/badge/platform-iOS%208%2B-blue.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=flat)](https://cocoapods.org)
[![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/jiecao-fm/SwiftTheme/blob/master/LICENSE)


A lightweight and pure Swift implemented library for switch app theme/skin. Chameleon aim at provide easy way to enable to app switch theme

If your have any question, you can email me(zhangbozhb@gmail.com) or leave message.

## Requirements

* iOS 8.0+
* Xcode 7.0 or above

## Usage
### Simple usage

##### Assume
You can define you theme with any data. Let's assume you theme data is ThemeStyle (Day, Night). ThemeStyle is enum type, however you can define your theme with any type.


**1**, Enable view to switch theme ability:
```swift
let label = UILabel()
label.ch.refreshBlock = { (now:Any, pre:Any?) -> Void in
    // your code change theme/skin
    if let now = ChameleonHelper<ThemeStyle>.parse(now) { // get your ThemeStyle from now
        label.text = "\(now)"
        ...
    }
}
```

Or your can override method of view: switchTheme(now:pre:), your should extension UIView/UIViewController to support ChameleonCallBackProtocol
```swift
override func switchTheme(now: Any, pre: Any?) {
    // your code change theme/skin
    if let now = ChameleonHelper<ThemeStyle>.parse(now) {
        ...
    }
}

// MARK: make UIView/UIViewController to support ChameleonCallBackProtocol
// This piece of code must be in your app/module: due to swift 3 restrict to extentsion of exist class(override is not available)
extension UIView : ChameleonCallBackProtocol {
    public func switchTheme(now: Any, pre: Any?){
    }
}

extension UIViewController : ChameleonCallBackProtocol {
    public func switchTheme(now: Any, pre: Any?){
    }
}
```
* now: data that you pass to switchTheme. your can use ChameleonHelper<ThemeStyle>.parse(now) get your real theme data
* pre: previous data that you pass to switchTheme


**2** Set your Theme
* Switch whole application theme
``` swift
    ThemeServiceConfig.shared.initTheme(data: ThemeStyle.Day)
```
* Note: if you not initThemeData, arg now in switchTheme(now:pre:) or ch.refreshBlock may nil

**3** Switch Theme
* Switch whole application theme
``` swift
    UIApplication.ch.refresh(with: ThemeStyle.Night)
```
* Switch specified view's theme (sub view as well)
``` swift
    viewInstance.ch.refresh(with: ThemeStyle.Night)
 ```
* Switch specified view controller's theme (child view controlls as well)
``` swift
    viewControllerInstance.ch.refresh(with: ThemeStyle.Night)
 ```

### Useful Helper Function
Some useful function define in ChameleonHelper.
* get current theme: ChameleonHelper<Your Defined Theme Class>.current
* get current theme from args: ChameleonHelper<Your Defined Theme Class>.parse()
* get current theme image: ChameleonHelper<Your Defined Theme Class>.image()
* get current theme color: ChameleonHelper<Your Defined Theme Class>.color()
* get current theme data, if your find image/color cannot satisfy your needs: ChameleonHelper<Your Defined Theme Class>.currentData()


### Advance usage

* 1, Auto callback config
    To save your time, ThemeServiceConfig may be your favor.
    Several properties are pre defined for you. When specified property is true, ch.refreshBlock or switchTheme(now:pre:) of ChameleonCallBackProtocol user it's parent data

    ```swift
        // config your theme switch
        ThemeServiceConfig.shared.autoSwitch = [.viewDidMoveToWindow, .viewControllerViewWillAppear]
    ```
    
    **Note**: Auto call is convenient and save your time, but you should follow some rules, or else you may be in trouble.
    
    * No Crash: Be aware you should promise you ChameleonCallBackProtocol and ch.refreshBlock If unfortunately it happened, you app will crash.
    * Save your status: You should save you status aware in some place, and theme switch method should status aware. since callback is automatic, if you theme or you appearance is status related, it may work not properly. For example, you has a button which theme is status related. Its background is black in Day, white in Night, and red if it selected; if you have never save your selection status or theme switch ignored selection status, auto callback will not work properly.


* 2, Call orders:
    * order between parent and child(view/subviews, view controller/ child view controller): child will call before parent;
    * ChameleonCallBackProtocol and ch.refreshBlock: if both defined, ChameleonCallBackProtocol run before ch.refreshBlock;
    * view, view controller: if your app switch theme, view theme switch related method run before view controller. If you change one view theme in both view and view controller, changes in view controller will take effect.
    
    **Note**:
    * View and View controller work separately. if you call ch.refresh in view controller, its view theme switch method will not run.


* 4, You may find your switch theme method not call when you view controller is beyond application rootViewController tree. In this case, you normal is call ch.register()
    ```
    viewControllerInstance.ch.register()
    ```
    In most cases, your do not need call this method, how ever your are free to call this method at any time


### Swift Version:
    default support is Swift 3. If you use it in Swift 2 you should use 1.x version.

### Migration:
   version 2.2 is break change. server changes should apply:

* 1, func ch_switchTheme(_ now: Any, pre: Any?) no longer available
    * a, your should extension UIView/UIViewController support ChameleonCallBackProtocol
    * b, rename to switchTheme(now: Any, pre: Any?)
* 2, ThemeSwitchHelper to ChameleonHelper
    * a, func currentTheme() to property current
* 3, ch_* function/property not available and use ch.* instead

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

``` bash
$ gem install cocoapods
```

To integrate ChameleonSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

``` ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ChameleonSwift'
```

Then, run the following command:

``` bash
$ pod install
```

You should open the `{Project}.xcworkspace` instead of the `{Project}.xcodeproj` after you installed anything from CocoaPods.


### Carthage
```bash
github "zhangbozhb/ChameleonSwift"
```



# ChameleonSwift 介绍
ChameleonSwift 提供了一种机制，你可以很方便的使得你的 App 具有多种皮肤和主题.。ChameleonSwift 是一个纯 Swift 实现的扩展。
由于主题/皮肤切换的复杂性，考虑到易于使用和可扩展行，本库并没有采用其他大多数库采用的方式（为不同的 view 添加不同的属性以达到主题切换），而是采用的是扩展 UIView, UIViewController的方式，你可以高度的定制你想要的皮肤。

和其他主题或者皮肤库优点：
* 简单。其他库在使用的时候，不同的View添加不同的属性，类型太多使用起来不容易
* 易于扩展。本库并没有单独的属性用于处理不同主题/皮肤下的表现，而是采用闭包的方式来实现，具有更大的灵活行和自主性
* 高度解耦：本扩展一个简单的配置，你可以专注与业务逻辑，而不需要考虑皮肤/主题支持使得你的代码变得丑陋不堪



## 简单使用：
### 第一步： view / view controller 支持多套皮肤/主题

##### 假设
假设你使用默认的 ThemeStyle（枚举类型,由Day, Night), 下面代码中使用 ThemeStyle 作为你使用的主题类型; 当然在实际使用中, 可以完成你自己定义的主题类型,可以是枚举,数字,类,可以是任意类型

有两种方式：你可以通过闭包，也可以通过 override 父类的方法来实现
闭包实现

```swift
let label = UILabel()
label.ch.refreshBlock = { (now:Any, pre:Any?) -> Void in
    // 你修改主题的代码
    if let now = ChameleonHelper<你定义的主题类型>.parse(now) { // 获取 真正的主题
        label.text = "\(now)"
        ...
    }
}
```
* 注意: now 通过 ChameleonHelper<你定义的主题类型>.current 获取当前的主题（后面步骤二传入的参数）
override ChameleonCallBackProtocol.switchTheme方法实现：
```swift
override func switchTheme(now: Any, pre: Any?) {
    // your code change theme/skin
    if let now = ChameleonHelper<ThemeStyle>.parse(now) {
        ...
    }
}

// MARK: 在你的代码中使得 UIView/UIViewController 实现 ChameleonCallBackProtocol
// 只需要在你的代码中添加一次即: 原因 swift 3禁止override 外部lib extension的方法
extension UIView : ChameleonCallBackProtocol {
    public func switchTheme(now: Any, pre: Any?){
    }
}

extension UIViewController : ChameleonCallBackProtocol {
    public func switchTheme(now: Any, pre: Any?){
    }
}
参数说明：
* now: 你切换主题是传递进来的参数，比如是白天，还是黑夜等待。你可以用 ChameleonHelper<你定义的主题类型>.parse(now),获取当前的主题
* pre: 上次你主题切换使用的参数
好了，通过上面的步骤你已经使得你的view可以支持多种主题了


### 第二步: 设置的主题数据
* 设置整个app
``` swift
    ThemeServiceConfig.shared.initTheme(data: ThemeStyle.Day)
```
* 设置单个view和subview
``` swift
    viewInstance.ch.refresh(with: ThemeStyle.Night)
 ```
* 设置单个 view controller 和其子 view controller
``` swift
    viewControllerInstance.ch.refresh(with: ThemeStyle.Night)
 ```

### 第三步：切换主题，皮肤
你只需要调用一个方法就可以实现
```swift
    UIApplication.ch.refresh(with: ThemeStyle.Night)
```


当然，你可以选择行的修改你想要改变view / view controller 的主题
view 切换调用:
```swift
    viewInstance.ch.refresh(with: ThemeStyle.Night)
```
view controller 调用:
```swift
    viewControllerInstance.ch.refresh(with: ThemeStyle.Night)
```

### Swift 版本问题
默认支持的为Swift 3版本,如果需要在 Swift 2 版本使用, 请使用 1.x的版本

## 有用的帮助函数
ChameleonHelper定义了一些有用的函数
* 获取当前的主题: ChameleonHelper<你定义的主题类型>.current
* 解析参数获取当前主题: ChameleonHelper<你定义的主题类型>.parse()
* 当前主题的图片: ChameleonHelper<你定义的主题类型>.image()
* 当前主题的颜色: ChameleonHelper<你定义的主题类型>.color()
* 当前主题的配置（如果图片,颜色不满足你的需求,你可以使用这个）: ChameleonHelper<你定义的主题类型>.currentData()


## 高级使用：
### 自动调用
在简单使用中，介绍了如何让你的 App 支持主题切换和如何进行切换。但是，你会发现还是很不方面，你需要不怨其烦的手动调用，主题修改的方法。为你将你从这种无止境的烦恼中解放出来。为你提供了主题切换自动调用配置 ThemeServiceConfig。提供的配置，可以满足你的绝大数需求。
* viewAutoSwitchThemeAfterAwakeFromNib： 在 view 从 nib 文件awake的时候，自动调用
* viewAutoSwitchThemeAfterMovedToWindow：在 view 被添加到windows上的时候，自动调用（为什么是这个方法而不是启发window呢？这个请看 apple 的官方文档， 对于 didMoveToWindow 的说明）
* viewControllerAutoSwitchThemeAfterAwakeFromNib：在 view controller 从 nib 文件awake的时候，自动调用
* viewControllerAutoSwitchThemeWhenViewWillAppear：在 view controller 即将显示之前的时候，自动调用

是不是，很方便，简单?

#### 注意
不过任何好用，其实都是由代价的，自动调用使得主题切换调用更隐晦，响应的也不容易调试。为了你更好的使用自动调用，几点注意事项
* 确保不抛出异常： ch.refreshBlock 或者 ChameleonCallBackProtocol， 不要抛出异常，否则会 crash
* 非主题相关的状态保存在 view 或者 view controller中： 比如 一个 view 具有选中属性，在选中不选中的时候由不同的外观，你需要在某个地方存放这个状态，否则外观会被主题切换破坏调用。比如你 主题切换会把背景色设置为白色或黑色，你的 App 在某个地方人为的设置为红色，而你有恰好的配置了自动调用，那么你可能会惊讶的发现 view 颜色不是你想要的红色，你需要考虑到这一点。比较方便的方式是，你用某种方式记录你设置的红色状态，在 主题切换的时候，发现为红色是不修改背景色。


### 常见问题：
* 1，闭包 ch.refreshBlock 和 ChameleonCallBackProtocol 同时存在，会出现什么问题？
闭包和ChameleonCallBackProtocol都会被调用，只不过闭包会在ChameleonCallBackProtocol调用的后面调用

* 2，view controller 主题切换闭包,函数没有调用.
如果一个修改主题的方法写在一个view controller中，而在使用的时候 只是将 controller的view添加到某个view上，而view controller本身没有加到任何 view controller下的时候， 可能出现 该 view contoller的方法，并没有自动调用或者在主题切换的时候也没有自动调用？怎么处理
其实出现这种情况是正常的，这个涉及到本库切换的设计原理（后面提到）。你需要人为的调用主题切换方法，并 viewControllerInstance.ch.register()进行注册。就可以实现
viewControllerInstance.ch.register() 这个方法在绝大多数的时候，你可以任何地方使用，不过建议在本情况出现的时候调用（可能导致调用顺序异常）
* 3，主题切换函数或闭包调用顺序问题：
    * 父子view（view controller）调用顺序：先调用子view（view controller）的，在调用父的(parent)
    * 对于单个 view（view controller）：先调用主题切换函数，然后再试主题切换闭包
    * view 和 view controller 调用顺序： App 主题切换的时候，先调用 view 的，然后才是 view controller的
    * view controller 主题切换不会调用其 view 的主题切换函数和闭包

### 迁移:
   版本 2.2 和以前的api是不兼容的, 重要的修改如下:

* 1, 移除函数 ch_switchTheme(_ now: Any, pre: Any?)
    * a, 手动扩展 UIView/UIViewController 支持 ChameleonCallBackProtocol
    * b, 重命名为 to switchTheme(now: Any, pre: Any?)
* 2, ThemeSwitchHelper 重命名为 ChameleonHelper
    * a, 函数 currentTheme() 修改为 函数 current()
* 3, ch_* 相关函数属性,修改为 ch.*

### 原理
采用的是扩展 view，view controller的方式来实现的。 主题切换的时候，是通过遍历 app 的view 和 view controller 树来实现切换的。


### 广告
本库已经在某新闻 App 中使用，经得住考验~
