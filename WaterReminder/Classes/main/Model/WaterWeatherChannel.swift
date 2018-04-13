//
//	WaterWeatherChannel.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherChannel : NSObject, NSCoding{

	var astronomy : WaterWeatherAstronomy!
	var atmosphere : WaterWeatherAtmosphere!
	var descriptionField : String!
	var image : WaterWeatherImage!
	var item : WaterWeatherItem!
	var language : String!
	var lastBuildDate : String!
	var link : String!
	var location : WaterWeatherLocation!
	var title : String!
	var ttl : String!
	var units : WaterWeatherUnit!
	var wind : WaterWeatherWind!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let astronomyJson = json["astronomy"]
		if !astronomyJson.isEmpty{
			astronomy = WaterWeatherAstronomy(fromJson: astronomyJson)
		}
		let atmosphereJson = json["atmosphere"]
		if !atmosphereJson.isEmpty{
			atmosphere = WaterWeatherAtmosphere(fromJson: atmosphereJson)
		}
		descriptionField = json["description"].stringValue
		let imageJson = json["image"]
		if !imageJson.isEmpty{
			image = WaterWeatherImage(fromJson: imageJson)
		}
		let itemJson = json["item"]
		if !itemJson.isEmpty{
			item = WaterWeatherItem(fromJson: itemJson)
		}
		language = json["language"].stringValue
		lastBuildDate = json["lastBuildDate"].stringValue
		link = json["link"].stringValue
		let locationJson = json["location"]
		if !locationJson.isEmpty{
			location = WaterWeatherLocation(fromJson: locationJson)
		}
		title = json["title"].stringValue
		ttl = json["ttl"].stringValue
		let unitsJson = json["units"]
		if !unitsJson.isEmpty{
			units = WaterWeatherUnit(fromJson: unitsJson)
		}
		let windJson = json["wind"]
		if !windJson.isEmpty{
			wind = WaterWeatherWind(fromJson: windJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if astronomy != nil{
			dictionary["astronomy"] = astronomy.toDictionary()
		}
		if atmosphere != nil{
			dictionary["atmosphere"] = atmosphere.toDictionary()
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if image != nil{
			dictionary["image"] = image.toDictionary()
		}
		if item != nil{
			dictionary["item"] = item.toDictionary()
		}
		if language != nil{
			dictionary["language"] = language
		}
		if lastBuildDate != nil{
			dictionary["lastBuildDate"] = lastBuildDate
		}
		if link != nil{
			dictionary["link"] = link
		}
		if location != nil{
			dictionary["location"] = location.toDictionary()
		}
		if title != nil{
			dictionary["title"] = title
		}
		if ttl != nil{
			dictionary["ttl"] = ttl
		}
		if units != nil{
			dictionary["units"] = units.toDictionary()
		}
		if wind != nil{
			dictionary["wind"] = wind.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         astronomy = aDecoder.decodeObject(forKey: "astronomy") as? WaterWeatherAstronomy
         atmosphere = aDecoder.decodeObject(forKey: "atmosphere") as? WaterWeatherAtmosphere
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         image = aDecoder.decodeObject(forKey: "image") as? WaterWeatherImage
         item = aDecoder.decodeObject(forKey: "item") as? WaterWeatherItem
         language = aDecoder.decodeObject(forKey: "language") as? String
         lastBuildDate = aDecoder.decodeObject(forKey: "lastBuildDate") as? String
         link = aDecoder.decodeObject(forKey: "link") as? String
         location = aDecoder.decodeObject(forKey: "location") as? WaterWeatherLocation
         title = aDecoder.decodeObject(forKey: "title") as? String
         ttl = aDecoder.decodeObject(forKey: "ttl") as? String
         units = aDecoder.decodeObject(forKey: "units") as? WaterWeatherUnit
         wind = aDecoder.decodeObject(forKey: "wind") as? WaterWeatherWind

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if astronomy != nil{
			aCoder.encode(astronomy, forKey: "astronomy")
		}
		if atmosphere != nil{
			aCoder.encode(atmosphere, forKey: "atmosphere")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if item != nil{
			aCoder.encode(item, forKey: "item")
		}
		if language != nil{
			aCoder.encode(language, forKey: "language")
		}
		if lastBuildDate != nil{
			aCoder.encode(lastBuildDate, forKey: "lastBuildDate")
		}
		if link != nil{
			aCoder.encode(link, forKey: "link")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if ttl != nil{
			aCoder.encode(ttl, forKey: "ttl")
		}
		if units != nil{
			aCoder.encode(units, forKey: "units")
		}
		if wind != nil{
			aCoder.encode(wind, forKey: "wind")
		}

	}

}
