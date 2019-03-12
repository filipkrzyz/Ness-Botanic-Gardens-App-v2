//
//  Constant.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 12/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

// Name of the initial database json file
let localNessDBjson = "nessdb_20190306"
let jsonLastUpdate = "2019-03-06 17:00:00"

// Database URL
let dbURL = URL(string: "https://student.csc.liv.ac.uk/~sgfkrzyz/ness/nessdb.php")!

// URL to access server folder with images
let imgURL = URL(string: "http://ness-gardens.csc.liv.ac.uk/image-store/")!

// URL of Ness official website
let nessURL = URL(string: "https://www.liverpool.ac.uk/ness-gardens/")!

// Colours
let atlanticBlue = UIColor(red: CGFloat(3)/255, green: CGFloat(31)/255, blue: CGFloat(115)/255, alpha: 1.0)
let sunriseGold = UIColor(red: CGFloat(161)/255, green: CGFloat(119)/255, blue: CGFloat(0)/255, alpha: 1.0)
let graphiteGrey = UIColor(red: CGFloat(60)/255, green: CGFloat(60)/255, blue: CGFloat(60)/255, alpha: 1.0)
let deepPlum = UIColor(red: CGFloat(92)/255, green: CGFloat(85)/255, blue: CGFloat(111)/255, alpha: 1.0)

let header1: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 25), .foregroundColor: atlanticBlue]
let header2: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: atlanticBlue]
let bodyText: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: graphiteGrey]



struct Marker {
    var markerID: Int
    var title: String?
    var snippet: String?
    var description: String?
    var latitude: String?
    var longitude: String?
    var icon: String?
    var entityName: String?
    var idProperty: String?
    var idValue: String?
    var marker: GMSMarker?
}

func convertCoordinateToDec(degrees: Double, minutes: Double, seconds: Double, direction: String) -> Double {
    let sign = (direction == "W" || direction == "S") ? -1.0 : 1.0
    return (degrees + (minutes + seconds/60.0)/60.0) * sign
}

struct NessDatabase: Decodable {
    var attractions: [Attraction]
    var bed: [Bed]
    var features: [Feature]
    var garden_sections: [GardenSection]
    var images: [Image]
    var itf2: [InternTransfForm2]
    var trail_locations: [TrailLocation]
    var trail_points: [TrailPoint]
    var trails: [Trail]
}

struct Attraction: Codable {
    
    var id: String?
    var uuid: String?
    var attraction_name: String?
    var symbol_name: String?
    var descript: String?
    var more_info_link: String?
    var latitude: String?
    var longitude: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
        case attraction_name = "attraction_name"
        case descript = "description"
        case symbol_name = "symbol_name"
        case more_info_link = "more_info_link"
        case latitude = "latitude"
        case longitude = "longitude"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}

struct Bed: Codable {
    var bed_id: String?
    var section_name: String?
    var location: String?   
    var latitude: String?
    var longitude: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case bed_id = "bed_id"
        case section_name = "section_name"
        case location = "location"
        case latitude = "latitude"
        case longitude = "longitude"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}


struct Feature: Decodable {
    var id: String?
    var name: String?
    var image_name: String?
    var latitude: String?
    var longitude: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case image_name = "image_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}

struct GardenSection: Decodable {
    var id: String?
    var name: String?
    var descript: String?
    var latitude: String?
    var longitude: String?
    var image_name1: String?
    var image_name2: String?
    var image_name3: String?
    var image_name4: String?
    var image_name5: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case descript = "description"
        case latitude = "latitude"
        case longitude = "longitude"
        case image_name1 = "image_name1"
        case image_name2 = "image_name2"
        case image_name3 = "image_name3"
        case image_name4 = "image_name4"
        case image_name5 = "image_name5"
        case enabled = "enabled"
        case last_update = "last_update"
    }
    
}

struct Image: Codable {
    var recnum: String?
    var img_file_name: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case recnum = "recnum"
        case img_file_name = "img_file_name"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}

struct InternTransfForm2: Codable {
    var recnum: String?     // Record Number - used for images
    var accsta: String?     // Accession Status (C-current, D-dead)
    var fam: String?        // Family Name
    var sp: String?         // Species Epithet - specific epithet of the name of the plant
    var gen: String?        // Genus Name - generic name of the plant
    var vernam: String?     // Vernacular Name - common name
    var cou: String?        // Country of Origin
    var latdeg: String?
    var latmin: String?
    var latsec: String?
    var latdir: String?
    var londeg: String?
    var lonmin: String?
    var lonsec: String?
    var londir: String?
    var sgu: String?        // Specific Geographic Unit
    var loc: String?        // Locality of collection
    var alt: String?        // Altitude
    var bed: String?        // Bed in Ness Botanic Garden (separated with space)
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case accsta = "accsta"
        case fam = "fam"
        case gen = "gen"
        case recnum = "recnum"
        case sp = "sp"
        case vernam = "vernam"
        case cou = "cou"
        case latdeg = "latdeg"
        case latmin = "latmin"
        case latsec = "latsec"
        case latdir = "latdir"
        case londeg = "londeg"
        case lonmin = "lonmin"
        case lonsec = "lonsec"
        case londir = "londir"
        case sgu = "sgu"
        case loc = "loc"
        case alt = "alt"
        case bed = "bed"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}


struct TrailLocation: Codable {
    var id: String?
    var uuid: String?
    var trail_id: String?
    var sequence_no: String?
    var latitude: String?
    var longitude: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
        case trail_id = "trail_id"
        case sequence_no = "sequence_no"
        case latitude = "latitude"
        case longitude = "longitude"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}

struct TrailPoint: Codable {
    var id: String?
    var uuid: String?
    var trail_id: String?
    var name: String?
    var descript: String?
    var latitude: String?
    var longitude: String?
    var image_name1: String?       // No images + not known where stored
    var image_name2: String?
    var image_name3: String?
    var image_name4: String?
    var image_name5: String?
    var enabled: String?        
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
        case trail_id = "trail_id"
        case name = "name"
        case descript = "description"
        case latitude = "latitude"
        case longitude = "longitude"
        case image_name1 = "image_name1"
        case image_name2 = "image_name2"
        case image_name3 = "image_name3"
        case image_name4 = "image_name4"
        case image_name5 = "image_name5"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}

struct Trail: Codable {
    var id: String?
    var uuid: String?
    var trail_name: String?
    var distance: String?
    var duration: String?   // In minutes
    var descript: String?
    var difficulty: String?
    var enabled: String?
    var last_update: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
        case trail_name = "trail_name"
        case distance = "distance"
        case duration = "duration"
        case descript = "description"
        case difficulty = "difficulty"
        case enabled = "enabled"
        case last_update = "last_update"
    }
}


