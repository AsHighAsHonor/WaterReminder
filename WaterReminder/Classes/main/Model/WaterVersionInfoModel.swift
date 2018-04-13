//
//	WaterVersionInfoModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON


class WaterVersionInfoModel : NSObject, NSCoding{
    
    var binary : WaterBinary!
    var build : String!
    var changelog : AnyObject!
    var directInstallUrl : String!
    var installUrl : String!
    var name : String!
    var updateUrl : String!
    var updatedAt : Int!
    var version : String!
    var versionShort : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let binaryJson = json["binary"]
        if !binaryJson.isEmpty{
            binary = WaterBinary(fromJson: binaryJson)
        }
        build = json["build"].stringValue
        changelog = json["changelog"].stringValue as AnyObject!
        directInstallUrl = json["direct_install_url"].stringValue
        installUrl = json["installUrl"].stringValue
        name = json["name"].stringValue
        updateUrl = json["update_url"].stringValue
        updatedAt = json["updated_at"].intValue
        version = json["version"].stringValue
        versionShort = json["versionShort"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if binary != nil{
            dictionary["binary"] = binary.toDictionary()
        }
        if build != nil{
            dictionary["build"] = build
        }
        if changelog != nil{
            dictionary["changelog"] = changelog
        }
        if directInstallUrl != nil{
            dictionary["direct_install_url"] = directInstallUrl
        }
        if installUrl != nil{
            dictionary["installUrl"] = installUrl
        }
        if name != nil{
            dictionary["name"] = name
        }
        if updateUrl != nil{
            dictionary["update_url"] = updateUrl
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if version != nil{
            dictionary["version"] = version
        }
        if versionShort != nil{
            dictionary["versionShort"] = versionShort
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        binary = aDecoder.decodeObject(forKey: "binary") as? WaterBinary
        build = aDecoder.decodeObject(forKey: "build") as? String
        changelog = aDecoder.decodeObject(forKey: "changelog") as AnyObject!
        directInstallUrl = aDecoder.decodeObject(forKey: "direct_install_url") as? String
        installUrl = aDecoder.decodeObject(forKey: "installUrl") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        updateUrl = aDecoder.decodeObject(forKey: "update_url") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int
        version = aDecoder.decodeObject(forKey: "version") as? String
        versionShort = aDecoder.decodeObject(forKey: "versionShort") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if binary != nil{
            aCoder.encode(binary, forKey: "binary")
        }
        if build != nil{
            aCoder.encode(build, forKey: "build")
        }
        if changelog != nil{
            aCoder.encode(changelog, forKey: "changelog")
        }
        if directInstallUrl != nil{
            aCoder.encode(directInstallUrl, forKey: "direct_install_url")
        }
        if installUrl != nil{
            aCoder.encode(installUrl, forKey: "installUrl")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if updateUrl != nil{
            aCoder.encode(updateUrl, forKey: "update_url")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if version != nil{
            aCoder.encode(version, forKey: "version")
        }
        if versionShort != nil{
            aCoder.encode(versionShort, forKey: "versionShort")
        }
        
    }
    
}
