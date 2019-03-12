//
//  Beds+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Beds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beds> {
        return NSFetchRequest<Beds>(entityName: "Beds")
    }

    @NSManaged public var bed_id: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latitude: String?
    @NSManaged public var location: String?
    @NSManaged public var longitude: String?
    @NSManaged public var enabled: String?
    @NSManaged public var section_name: String?

}
