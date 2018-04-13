//
//	WaterWeatherAstronomy.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherAstronomy : NSObject, NSCoding{

	var sunrise : String!
	var sunset : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		sunrise = json["sunrise"].stringValue
		sunset = json["sunset"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if sunrise != nil{
			dictionary["sunrise"] = sunrise
		}
		if sunset != nil{
			dictionary["sunset"] = sunset
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         sunrise = aDecoder.decodeObject(forKey: "sunrise") as? String
         sunset = aDecoder.decodeObject(forKey: "sunset") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if sunrise != nil{
			aCoder.encode(sunrise, forKey: "sunrise")
		}
		if sunset != nil{
			aCoder.encode(sunset, forKey: "sunset")
		}

	}

}
