//
//  AlarmInfosEntiy+CoreDataProperties.swift
//  
//
//  Created by YYang on 04/02/2017.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension AlarmInfosEntiy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmInfosEntiy> {
        return NSFetchRequest<AlarmInfosEntiy>(entityName: "AlarmInfosEntiy");
    }

    @NSManaged public var identifier: String
    @NSManaged public var time: String
    @NSManaged public var isRepeat: Bool
    @NSManaged public var isOn: Bool
    @NSManaged public var title: String
    @NSManaged public var subtitle: String
    @NSManaged public var body: String
    @NSManaged public var badge: Int16
    @NSManaged public var sound: String
    @NSManaged public var timeType: String
    @NSManaged public var showTitle: String


}
