//
//  Itf2+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 22/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Itf2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Itf2> {
        return NSFetchRequest<Itf2>(entityName: "Itf2")
    }

    @NSManaged public var accsta: String?
    @NSManaged public var alt: String?
    @NSManaged public var bed: String?
    @NSManaged public var cou: String?
    @NSManaged public var enabled: String?
    @NSManaged public var fam: String?
    @NSManaged public var gen: String?
    @NSManaged public var last_update: String?
    @NSManaged public var latdeg: String?
    @NSManaged public var latdir: String?
    @NSManaged public var latmin: String?
    @NSManaged public var latsec: String?
    @NSManaged public var loc: String?
    @NSManaged public var londeg: String?
    @NSManaged public var londir: String?
    @NSManaged public var lonmin: String?
    @NSManaged public var lonsec: String?
    @NSManaged public var recnum: String?
    @NSManaged public var sgu: String?
    @NSManaged public var sp: String?
    @NSManaged public var vernam: String?

}
