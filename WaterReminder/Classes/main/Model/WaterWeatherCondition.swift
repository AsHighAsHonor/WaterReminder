//
//	WaterWeatherCondition.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherCondition : NSObject, NSCoding{

	var code : String!
	var date : String!
	var temp : String!
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
		temp = json["temp"].stringValue
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
		if temp != nil{
			dictionary["temp"] = temp
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
         temp = aDecoder.decodeObject(forKey: "temp") as? String
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
		if temp != nil{
			aCoder.encode(temp, forKey: "temp")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}

	}

}
