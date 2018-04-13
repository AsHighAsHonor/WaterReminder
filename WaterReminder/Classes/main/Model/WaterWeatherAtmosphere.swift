//
//	WaterWeatherAtmosphere.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherAtmosphere : NSObject, NSCoding{

	var humidity : String!
	var pressure : String!
	var rising : String!
	var visibility : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		humidity = json["humidity"].stringValue
		pressure = json["pressure"].stringValue
		rising = json["rising"].stringValue
		visibility = json["visibility"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if humidity != nil{
			dictionary["humidity"] = humidity
		}
		if pressure != nil{
			dictionary["pressure"] = pressure
		}
		if rising != nil{
			dictionary["rising"] = rising
		}
		if visibility != nil{
			dictionary["visibility"] = visibility
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         humidity = aDecoder.decodeObject(forKey: "humidity") as? String
         pressure = aDecoder.decodeObject(forKey: "pressure") as? String
         rising = aDecoder.decodeObject(forKey: "rising") as? String
         visibility = aDecoder.decodeObject(forKey: "visibility") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if humidity != nil{
			aCoder.encode(humidity, forKey: "humidity")
		}
		if pressure != nil{
			aCoder.encode(pressure, forKey: "pressure")
		}
		if rising != nil{
			aCoder.encode(rising, forKey: "rising")
		}
		if visibility != nil{
			aCoder.encode(visibility, forKey: "visibility")
		}

	}

}
