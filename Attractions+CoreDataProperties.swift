//
//  Attractions+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Attractions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attractions> {
        return NSFetchRequest<Attractions>(entityName: "Attractions")
    }

    @NSManaged public var enabled: String?
    @NSManaged public var attraction_name: String?
    @NSManaged public var descript: String?
    @NSManaged public var id: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var more_info_link: String?
    @NSManaged public var symbol_name: String?
    @NSManaged public var uuid: String?

}
