//
//	WaterWeatherQuery.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherQuery : NSObject, NSCoding{

	var count : Int!
	var created : String!
	var lang : String!
	var results : WaterWeatherResult!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		count = json["count"].intValue
		created = json["created"].stringValue
		lang = json["lang"].stringValue
		let resultsJson = json["results"]
		if !resultsJson.isEmpty{
			results = WaterWeatherResult(fromJson: resultsJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if count != nil{
			dictionary["count"] = count
		}
		if created != nil{
			dictionary["created"] = created
		}
		if lang != nil{
			dictionary["lang"] = lang
		}
		if results != nil{
			dictionary["results"] = results.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         count = aDecoder.decodeObject(forKey: "count") as? Int
         created = aDecoder.decodeObject(forKey: "created") as? String
         lang = aDecoder.decodeObject(forKey: "lang") as? String
         results = aDecoder.decodeObject(forKey: "results") as? WaterWeatherResult

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if count != nil{
			aCoder.encode(count, forKey: "count")
		}
		if created != nil{
			aCoder.encode(created, forKey: "created")
		}
		if lang != nil{
			aCoder.encode(lang, forKey: "lang")
		}
		if results != nil{
			aCoder.encode(results, forKey: "results")
		}

	}

}
