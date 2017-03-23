//
//  CLPlacemarkExtension.swift
//  WaterReminder
//
//  Created by YYang on 20/03/2017.
//  Copyright © 2017 YYang. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
   public func placeHigherLevelDescription() -> String {
        var placeStr = ""
        //县区
        if let subLocality = self.subLocality {
            placeStr.append(",\(subLocality)")
        }
        //地级市
        if let locality = self.locality {
            placeStr.append(",\(locality)")
        }
        //省 直辖市
        if let administrativeArea = self.administrativeArea {
            placeStr.append(",\(administrativeArea)")
        }
        //国家
        if let country = self.country {
            placeStr.append(",\(country)")
        }
    
    //从1个长度后开始截取字符串 删除开头的 " , "
    placeStr = placeStr.substring(from: "a".endIndex)
    
        return placeStr
    }
    
    public func placeLowerLevelDescription() -> String {
        var placeStr = ""
        if let name = self.name {
            placeStr.append(",\(name)")
        }
        //子街道
        if let subThoroughfare = self.subThoroughfare {
            placeStr.append(",\(subThoroughfare)")
        }
        //街道
        if let thoroughfare = self.thoroughfare {
            placeStr.append(",\(thoroughfare)")
        }
        //从1个长度后开始截取字符串 删除开头的 " , "
        placeStr = placeStr.substring(from: "a".endIndex)
        
        return placeStr
    }
    
}
