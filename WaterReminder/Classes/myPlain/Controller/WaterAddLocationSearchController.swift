//
//  WaterAddLocationSearchController.swift
//  WaterReminder
//
//  Created by YYang on 18/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import UIKit
import Universal
import CoreLocation


/// tableView 数据源类型
///
/// - SearchResult: 搜索结果
/// - History: 搜索历史
/// - FilterResult: 过滤结果
enum DataSourceType : String {
    case SearchResult = "SearchResult"
    case History = "History"
    case FilterResult = "FilterResult"
}

class WaterAddLocationSearchController: UIViewController {
    // MARK: - Initliazation
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
//        self.myTableView.registeCell(UITableViewCell.self, isClass: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //保存搜索历史到缓存
        _ = CacheUtil.userDefaultsOperation(value: searchHistory, key: UserSetting.LocationHistory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //从缓存读取保存的搜索历史
        if let history = CacheUtil.userDefaultsOperation(value: nil, key: UserSetting.LocationHistory) as? Array<String> {
            searchHistory.append(contentsOf:history )
            sourceType = .History
        }
    }
    
    
    // MARK: - Properties
    
    
    ///选中查询结果时回调
    public var selectedPlaceClosure : ((_ : CLPlacemark)->Void)?
    
    /// 数据源类型
    fileprivate var sourceType : DataSourceType = .History{
        didSet{
            if sourceType == .History{
                self.clearBtn.isHidden = false //显示清除按钮
            }else{
                self.clearBtn.isHidden = true //隐藏清除按钮
            }
            myTableView.reloadData()  //刷新
        }
    }

    
    /// UISearchController
   fileprivate var searchController: UISearchController!
    
    @IBOutlet weak var myTableView: UITableView!
    
    /// 地理编码 查询结果
   fileprivate var searchResults : Array<CLPlacemark>? = []
    
    /// 清空历史记录
    @IBOutlet weak var clearBtn: UIButton!
    
    
    /// 查询历史
   fileprivate lazy var searchHistory : Array = {
        return Array<String>()
    }()
    
    
    /// 过滤结果
   fileprivate lazy var filteredResult : Array = {
        return Array<String>()
    }()
    
    
    /// 地理工具
  fileprivate let locationUtil = LocationUtil()
    
    
    
}


// MARK: - EventResponses
extension WaterAddLocationSearchController{
    ///返回按钮
    @IBAction func BackBtnClicked(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clearHistoryBtnClicked(_ sender: Any) {
        //清空历史记录
        UIAlertController.showAlert(message: "确定清除历史记录吗?".localized(), in: self, sureHandler: { (UIAlertAction) in
            _ = CacheUtil.userDefaultsOperation(value: [], key: UserSetting.LocationHistory)
            self.searchHistory.removeAll()
            self.myTableView.reloadData()
        }, cancelHandler: nil)
        
    }
    
}

// MARK: - PrivateMethods
extension WaterAddLocationSearchController {
    
    /// 根据关键字查询地理信息
    ///
    /// - Parameter keyword: 关键字
    fileprivate func search(keyword : String)  {
        //1.保存搜索地址
        if !searchHistory.contains(keyword) {
            //不重复保存
            searchHistory.append(keyword)
        }
        self.sourceType = .History
        filteredResult.removeAll()
        
        //2.地理编码
        locationUtil.GeocodeAddrStr(locationStr: keyword) { [unowned self](places) in
            YYPrint(places.debugDescription)
            self.searchResults = places
            self.sourceType = .SearchResult
        }
    }
    
}

// MARK: - DelegateMethods
// MARK: TableViewDelegate
extension WaterAddLocationSearchController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sourceType {
        case .History:
            return  searchHistory.count
        case .SearchResult:
            return searchResults!.count //查询结果为空 默认值0
        case .FilterResult:
            return filteredResult.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reid =  String(describing: UITableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier:reid)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reid)
        }
//        let cell = self.myTableView.dequeue(IndexPath: indexPath)
        switch sourceType {
        case .History:
            cell?.textLabel?.text = searchHistory[indexPath.row]
        case .SearchResult:
            cell?.detailTextLabel?.text = searchResults?[indexPath.row].placeHigherLevelDescription()//国家 省 市 区
            cell?.textLabel?.text = searchResults?[indexPath.row].placeLowerLevelDescription() // 街道 子街道 名称
        case .FilterResult:
            cell?.textLabel?.text = filteredResult[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sourceType {
        case .History , .FilterResult:
            //用历史地址再次查询
            search(keyword: searchHistory[indexPath.row])
            
        case .SearchResult :
            //传值回上一个页面选中的place : CLPlacemark
            self.selectedPlaceClosure!((searchResults?[indexPath.row])!)
            self.searchController.dismiss(animated: false, completion: nil) //dissmiss searchController
            self.dismiss(animated: false, completion: nil) //dismiss selfcontroller
        }
    }
    
}

// MARK: UISearchBarDelegate
extension WaterAddLocationSearchController : UISearchBarDelegate,UISearchResultsUpdating{
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "请输入要搜索的地名".localized()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        //以下两个方法解决UISearchController 每次上移20 的问题 !!!!!!!!!
        definesPresentationContext = true
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        myTableView.tableHeaderView = searchController.searchBar //将 searchBar 添加到导航
    }
    
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        sourceType = .History
        filteredResult.removeAll()
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
        guard let addrStr = searchBar.text else {
            toast(msg: "请先输入地址".localized())
            return
        }
        search(keyword: addrStr)
    }
    
    //输入框内容变化时
    func updateSearchResults(for searchController: UISearchController) {
        if  let keyword = searchController.searchBar.text {
            guard !keyword.isEmpty else {
                //刚开始输入或者清空输入框时
                sourceType = .History
                return
            }
            //过滤历史记录中包含查询关键字的内容
            filteredResult = searchHistory.filter({ (his) -> Bool in
                return his.contains(keyword)
            })
            sourceType = .FilterResult
        }
    }
}

// MARK:UISearchControllerDelegate
extension WaterAddLocationSearchController : UISearchControllerDelegate{
    func willDismissSearchController(_ searchController: UISearchController) {
    }
    
}

// MARK: - Navigation
extension WaterAddLocationSearchController{
    
}



