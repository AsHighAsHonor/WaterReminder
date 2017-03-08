//
//	WaterWeatherRootClass.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherRootClass : NSObject, NSCoding{

	var query : WaterWeatherQuery!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let queryJson = json["query"]
		if !queryJson.isEmpty{
			query = WaterWeatherQuery(fromJson: queryJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if query != nil{
			dictionary["query"] = query.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         query = aDecoder.decodeObject(forKey: "query") as? WaterWeatherQuery

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if query != nil{
			aCoder.encode(query, forKey: "query")
		}

	}

}
