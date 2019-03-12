//
//  Trail_locations+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Trail_locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trail_locations> {
        return NSFetchRequest<Trail_locations>(entityName: "Trail_locations")
    }

    @NSManaged public var enabled: String?
    @NSManaged public var id: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var sequence_no: String?
    @NSManaged public var trail_id: String?
    @NSManaged public var uuid: String?

}
