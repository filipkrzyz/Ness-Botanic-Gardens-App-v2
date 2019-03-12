//
//  Conifer_data+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Conifer_data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conifer_data> {
        return NSFetchRequest<Conifer_data>(entityName: "Conifer_data")
    }

    @NSManaged public var bark: String?
    @NSManaged public var commonName: String?
    @NSManaged public var distribution: String?
    @NSManaged public var evergreenDeciduous: String?
    @NSManaged public var family: String?
    @NSManaged public var femaleFlowers: String?
    @NSManaged public var finalHeight: String?
    @NSManaged public var fruitShape: String?
    @NSManaged public var fruitSize: String?
    @NSManaged public var fruitType: String?
    @NSManaged public var growthForm: String?
    @NSManaged public var growthHabit: String?
    @NSManaged public var last_update: String?
    @NSManaged public var leafArrangement: String?
    @NSManaged public var leafShape: String?
    @NSManaged public var leafSize: String?
    @NSManaged public var maleFlowers: String?
    @NSManaged public var monoeciousDioecious: String?
    @NSManaged public var notableLocation: [String]?
    @NSManaged public var notablePlantsAtNess: String?
    @NSManaged public var notes: String?
    @NSManaged public var notesOnGenus: String?
    @NSManaged public var order: String?
    @NSManaged public var otherFruitCharacteristics: String?
    @NSManaged public var plantID: String?
    @NSManaged public var plantImage: String?
    @NSManaged public var plantImageSmall: String?
    @NSManaged public var scientificName: String?

}
