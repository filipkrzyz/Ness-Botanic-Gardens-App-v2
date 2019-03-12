//
//  Trails+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Trails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trails> {
        return NSFetchRequest<Trails>(entityName: "Trails")
    }

    @NSManaged public var enabled: String?
    @NSManaged public var descript: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var distance: String?
    @NSManaged public var duration: String?
    @NSManaged public var id: String?
    @NSManaged public var last_update: String?
    @NSManaged public var trail_name: String?
    @NSManaged public var uuid: String?

}
