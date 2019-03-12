//
//  Features+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 22/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Features {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Features> {
        return NSFetchRequest<Features>(entityName: "Features")
    }

    @NSManaged public var enabled: String?
    @NSManaged public var id: String?
    @NSManaged public var image_name: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?

}
