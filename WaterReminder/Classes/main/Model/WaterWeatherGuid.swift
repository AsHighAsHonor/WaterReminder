//
//	WaterWeatherGuid.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherGuid : NSObject, NSCoding{

	var isPermaLink : Bool!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		isPermaLink = json["isPermaLink"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if isPermaLink != nil{
			dictionary["isPermaLink"] = isPermaLink
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isPermaLink = aDecoder.decodeObject(forKey: "isPermaLink") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if isPermaLink != nil{
			aCoder.encode(isPermaLink, forKey: "isPermaLink")
		}

	}

}
