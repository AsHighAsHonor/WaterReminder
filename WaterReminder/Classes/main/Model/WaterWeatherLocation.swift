//
//	WaterWeatherLocation.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherLocation : NSObject, NSCoding{

	var city : String!
	var country : String!
	var region : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		city = json["city"].stringValue
		country = json["country"].stringValue
		region = json["region"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
		}
		if region != nil{
			dictionary["region"] = region
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         city = aDecoder.decodeObject(forKey: "city") as? String
         country = aDecoder.decodeObject(forKey: "country") as? String
         region = aDecoder.decodeObject(forKey: "region") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if region != nil{
			aCoder.encode(region, forKey: "region")
		}

	}

}
