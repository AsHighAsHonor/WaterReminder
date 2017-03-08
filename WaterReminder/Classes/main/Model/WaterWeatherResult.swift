//
//	WaterWeatherResult.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherResult : NSObject, NSCoding{

	var channel : WaterWeatherChannel!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let channelJson = json["channel"]
		if !channelJson.isEmpty{
			channel = WaterWeatherChannel(fromJson: channelJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if channel != nil{
			dictionary["channel"] = channel.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         channel = aDecoder.decodeObject(forKey: "channel") as? WaterWeatherChannel

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if channel != nil{
			aCoder.encode(channel, forKey: "channel")
		}

	}

}
