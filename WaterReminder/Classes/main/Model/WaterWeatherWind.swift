//
//	WaterWeatherWind.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherWind : NSObject, NSCoding{

	var chill : String!
	var direction : String!
	var speed : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		chill = json["chill"].stringValue
		direction = json["direction"].stringValue
		speed = json["speed"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if chill != nil{
			dictionary["chill"] = chill
		}
		if direction != nil{
			dictionary["direction"] = direction
		}
		if speed != nil{
			dictionary["speed"] = speed
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chill = aDecoder.decodeObject(forKey: "chill") as? String
         direction = aDecoder.decodeObject(forKey: "direction") as? String
         speed = aDecoder.decodeObject(forKey: "speed") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if chill != nil{
			aCoder.encode(chill, forKey: "chill")
		}
		if direction != nil{
			aCoder.encode(direction, forKey: "direction")
		}
		if speed != nil{
			aCoder.encode(speed, forKey: "speed")
		}

	}

}
