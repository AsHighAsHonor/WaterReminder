//
//	WaterWeatherUnit.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherUnit : NSObject, NSCoding{

	var distance : String!
	var pressure : String!
	var speed : String!
	var temperature : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		distance = json["distance"].stringValue
		pressure = json["pressure"].stringValue
		speed = json["speed"].stringValue
		temperature = json["temperature"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if distance != nil{
			dictionary["distance"] = distance
		}
		if pressure != nil{
			dictionary["pressure"] = pressure
		}
		if speed != nil{
			dictionary["speed"] = speed
		}
		if temperature != nil{
			dictionary["temperature"] = temperature
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         distance = aDecoder.decodeObject(forKey: "distance") as? String
         pressure = aDecoder.decodeObject(forKey: "pressure") as? String
         speed = aDecoder.decodeObject(forKey: "speed") as? String
         temperature = aDecoder.decodeObject(forKey: "temperature") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if pressure != nil{
			aCoder.encode(pressure, forKey: "pressure")
		}
		if speed != nil{
			aCoder.encode(speed, forKey: "speed")
		}
		if temperature != nil{
			aCoder.encode(temperature, forKey: "temperature")
		}

	}

}
