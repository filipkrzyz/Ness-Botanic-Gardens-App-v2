//
//  Garden_sections+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Garden_sections {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garden_sections> {
        return NSFetchRequest<Garden_sections>(entityName: "Garden_sections")
    }

    @NSManaged public var enabled: String?
    @NSManaged public var descript: String?
    @NSManaged public var id: String?
    @NSManaged public var image_name1: String?
    @NSManaged public var image_name2: String?
    @NSManaged public var image_name3: String?
    @NSManaged public var image_name4: String?
    @NSManaged public var image_name5: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?

}
