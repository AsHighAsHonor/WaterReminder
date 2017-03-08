//
//	WaterWeatherItem.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherItem : NSObject, NSCoding{

	var condition : WaterWeatherCondition!
	var descriptionField : String!
	var forecast : [WaterWeatherForecast]!
	var guid : WaterWeatherGuid!
	var lat : String!
	var link : String!
	var longField : String!
	var pubDate : String!
	var title : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let conditionJson = json["condition"]
		if !conditionJson.isEmpty{
			condition = WaterWeatherCondition(fromJson: conditionJson)
		}
		descriptionField = json["description"].stringValue
		forecast = [WaterWeatherForecast]()
		let forecastArray = json["forecast"].arrayValue
		for forecastJson in forecastArray{
			let value = WaterWeatherForecast(fromJson: forecastJson)
			forecast.append(value)
		}
		let guidJson = json["guid"]
		if !guidJson.isEmpty{
			guid = WaterWeatherGuid(fromJson: guidJson)
		}
		lat = json["lat"].stringValue
		link = json["link"].stringValue
		longField = json["long"].stringValue
		pubDate = json["pubDate"].stringValue
		title = json["title"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if condition != nil{
			dictionary["condition"] = condition.toDictionary()
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if forecast != nil{
			var dictionaryElements = [[String:Any]]()
			for forecastElement in forecast {
				dictionaryElements.append(forecastElement.toDictionary())
			}
			dictionary["forecast"] = dictionaryElements
		}
		if guid != nil{
			dictionary["guid"] = guid.toDictionary()
		}
		if lat != nil{
			dictionary["lat"] = lat
		}
		if link != nil{
			dictionary["link"] = link
		}
		if longField != nil{
			dictionary["long"] = longField
		}
		if pubDate != nil{
			dictionary["pubDate"] = pubDate
		}
		if title != nil{
			dictionary["title"] = title
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         condition = aDecoder.decodeObject(forKey: "condition") as? WaterWeatherCondition
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         forecast = aDecoder.decodeObject(forKey: "forecast") as? [WaterWeatherForecast]
         guid = aDecoder.decodeObject(forKey: "guid") as? WaterWeatherGuid
         lat = aDecoder.decodeObject(forKey: "lat") as? String
         link = aDecoder.decodeObject(forKey: "link") as? String
         longField = aDecoder.decodeObject(forKey: "long") as? String
         pubDate = aDecoder.decodeObject(forKey: "pubDate") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if condition != nil{
			aCoder.encode(condition, forKey: "condition")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if forecast != nil{
			aCoder.encode(forecast, forKey: "forecast")
		}
		if guid != nil{
			aCoder.encode(guid, forKey: "guid")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if link != nil{
			aCoder.encode(link, forKey: "link")
		}
		if longField != nil{
			aCoder.encode(longField, forKey: "long")
		}
		if pubDate != nil{
			aCoder.encode(pubDate, forKey: "pubDate")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}
