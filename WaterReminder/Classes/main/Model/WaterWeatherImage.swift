//
//	WaterWeatherImage.swift
//	https://ashighashonor.github.io

import Foundation 
import SwiftyJSON


class WaterWeatherImage : NSObject, NSCoding{

	var height : String!
	var link : String!
	var title : String!
	var url : String!
	var width : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		height = json["height"].stringValue
		link = json["link"].stringValue
		title = json["title"].stringValue
		url = json["url"].stringValue
		width = json["width"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if height != nil{
			dictionary["height"] = height
		}
		if link != nil{
			dictionary["link"] = link
		}
		if title != nil{
			dictionary["title"] = title
		}
		if url != nil{
			dictionary["url"] = url
		}
		if width != nil{
			dictionary["width"] = width
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         height = aDecoder.decodeObject(forKey: "height") as? String
         link = aDecoder.decodeObject(forKey: "link") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String
         width = aDecoder.decodeObject(forKey: "width") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if height != nil{
			aCoder.encode(height, forKey: "height")
		}
		if link != nil{
			aCoder.encode(link, forKey: "link")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if url != nil{
			aCoder.encode(url, forKey: "url")
		}
		if width != nil{
			aCoder.encode(width, forKey: "width")
		}

	}

}
