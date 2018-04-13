//
//	WaterWeatherForecast.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherForecast : NSObject, NSCoding{

	var code : String!
	var date : String!
	var day : String!
	var high : String!
	var low : String!
	var text : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		code = json["code"].stringValue
		date = json["date"].stringValue
		day = json["day"].stringValue
		high = json["high"].stringValue
		low = json["low"].stringValue
		text = json["text"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if code != nil{
			dictionary["code"] = code
		}
		if date != nil{
			dictionary["date"] = date
		}
		if day != nil{
			dictionary["day"] = day
		}
		if high != nil{
			dictionary["high"] = high
		}
		if low != nil{
			dictionary["low"] = low
		}
		if text != nil{
			dictionary["text"] = text
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         code = aDecoder.decodeObject(forKey: "code") as? String
         date = aDecoder.decodeObject(forKey: "date") as? String
         day = aDecoder.decodeObject(forKey: "day") as? String
         high = aDecoder.decodeObject(forKey: "high") as? String
         low = aDecoder.decodeObject(forKey: "low") as? String
         text = aDecoder.decodeObject(forKey: "text") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if date != nil{
			aCoder.encode(date, forKey: "date")
		}
		if day != nil{
			aCoder.encode(day, forKey: "day")
		}
		if high != nil{
			aCoder.encode(high, forKey: "high")
		}
		if low != nil{
			aCoder.encode(low, forKey: "low")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}

	}

}
