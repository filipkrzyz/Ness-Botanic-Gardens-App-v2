//
//  Ness_spec+CoreDataProperties.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 19/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Ness_spec {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ness_spec> {
        return NSFetchRequest<Ness_spec>(entityName: "Ness_spec")
    }

    @NSManaged public var agg: String?
    @NSManaged public var clav: String?
    @NSManaged public var cost: String?
    @NSManaged public var ctbk: String?
    @NSManaged public var drog: String?
    @NSManaged public var gfth: String?
    @NSManaged public var ggg: String?
    @NSManaged public var gglo: String?
    @NSManaged public var ggrs: String?
    @NSManaged public var glar: String?
    @NSManaged public var glund: String?
    @NSManaged public var gmltc: String?
    @NSManaged public var gpurb: String?
    @NSManaged public var gscet: String?
    @NSManaged public var gsea: String?
    @NSManaged public var gswr: String?
    @NSManaged public var gvar: String?
    @NSManaged public var gyel: String?
    @NSManaged public var hard: String?
    @NSManaged public var heart: String?
    @NSManaged public var hevs: String?
    @NSManaged public var infr: String?
    @NSManaged public var leaf: String?
    @NSManaged public var lfespn: String?
    @NSManaged public var light: String?
    @NSManaged public var moist: String?
    @NSManaged public var mszh: String?
    @NSManaged public var mszw: String?
    @NSManaged public var pol: String?
    @NSManaged public var r2col: String?
    @NSManaged public var rcol: String?
    @NSManaged public var recnum: String?
    @NSManaged public var rfm: String?
    @NSManaged public var rsea: String?
    @NSManaged public var sand: String?
    @NSManaged public var snk: String?
    @NSManaged public var solph: String?
    @NSManaged public var type: String?
    @NSManaged public var urban: String?
    @NSManaged public var vth1: String?
    @NSManaged public var vth5: String?
    @NSManaged public var vth10: String?
    @NSManaged public var vth20: String?
    @NSManaged public var w2col: String?
    @NSManaged public var water: String?
    @NSManaged public var wcol: String?
    @NSManaged public var wfm: String?
    @NSManaged public var wind: String?
    @NSManaged public var wscet: String?
    @NSManaged public var wsea: String?
    @NSManaged public var wsz: String?

}
