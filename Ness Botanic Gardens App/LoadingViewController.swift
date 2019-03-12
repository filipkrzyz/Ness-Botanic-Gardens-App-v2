//
//  LoadingViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 12/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class LoadingViewController: UIViewController {

    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // Used to store JSON result from the DB url
    var nessDatabase: NessDatabase?
    
    // Current Date used to save after update
    var currentDate: String?
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Date format used for timestamp of Last_Update
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentDate = dateFormatter.string(from: date)
        
        activityIndicator.startAnimating()
        
        processingData {
            // We give at least 2sec of loading screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
                self.performSegue(withIdentifier: "home", sender: self)
            }
            
            // Saving the current date to persistent storage to represent date on which data was processed (updated)
            UserDefaults.standard.set(self.currentDate, forKey:"lastUpdate")
            print("Data updated on: ",UserDefaults.standard.object(forKey:"lastUpdate")!)
            
            
        }
        /////////////// TODO: Handle errors with downloading data   /////////////////////
        
    } // <-viewDidLoad
    
    
    
    func processingData(completionHandler: @escaping () -> Void) {
        
        // Referencing AppDelegate because it has some functions neccessary for using Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
            
            // Importing data into Core Data from JSON needs to be done in a private queue context so that it doesn't block main queue
            appDelegate.persistentContainer.performBackgroundTask { (context) in
                
                // If it is the first time the app is run request all data from the web server, save into Core Data, and save the current date to persistent storage to represent date on which data was downloaded
                if UserDefaults.standard.object(forKey: "lastUpdate") == nil {
                    
                    print("First time running, now I will download data, please wait")
                    
                    if let path = Bundle.main.path(forResource: localNessDBjson, ofType: "json") {
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                            self.nessDatabase = try JSONDecoder().decode(NessDatabase.self, from: data)
                        } catch let jsonErr{
                            print("Error serialising JSON: ", jsonErr)
                        }
                    }
                    
                    //  SAVING INTO CORE DATA
                    
                    // Creating Mirror reflecting nessDatabase
                    let databaseMirror = Mirror(reflecting: self.nessDatabase!)
                    
                    // Accessing properties of the nessDatabase structure
                    for (dbTableName, tableContent) in databaseMirror.children {
                        //print("\(dbTableName!): \(tableContent) \n")
                        
                        // Used to create new Entity to save in Core Data
                        var entity: NSManagedObject?
                        
                        // For each row in table (tableContent) of (dbTableName)
                        for row in tableContent as! [Any] {
                            
                            // Create Mirror of the row which is a structure of particular table
                            let rowMirror = Mirror(reflecting: row)
                            
                            // Check whether enabled is 1
                            if String(describing: self.unwrap(any: rowMirror.descendant("enabled")! as Any)) == "1" {
                                
                                // Check which table is being currently read in order to create corresponding Entity
                                switch (dbTableName!) {
                                case "attractions": entity = Attractions(context: context)
                                case "bed": entity = Beds(context: context)
                                //case "ConiferData": entity = Conifer_data(context: context)
                                case "features": entity = Features(context: context)
                                case "garden_sections": entity = Garden_sections(context: context)
                                case "images": entity = Images(context: context)
                                case "itf2": entity = Itf2(context: context)
                                case "trail_locations": entity = Trail_locations(context: context)
                                case "trail_points": entity = Trail_points(context: context)
                                case "trails": entity = Trails(context: context)
                                default: print("dbTableName didn't match any cases! "); break
                                }
                                
                                // Access properties of table's structure and set values in new created entity
                                for (tableProperty, content) in rowMirror.children {
                                    entity?.setValue(content as? String, forKey: tableProperty!)
                                }
                                
                                // Save new entity to Core Data context
                                do {
                                    try context.save()
                                } catch {
                                    print("Failed saving")
                                }
                            }
                        }
                    }
                    
                    UserDefaults.standard.set(jsonLastUpdate, forKey:"lastUpdate")
                    print("Data retrieved from local json updated on: ",UserDefaults.standard.object(forKey:"lastUpdate")!)
                
                
                    //completionHandler() // dataProcessing completed

                }   // <-- local JSON
                
////////////// RETRIEVE CORE DATA AND CHECK WITH SERVER FOR UPDATES  ///////////////////
                
                if UserDefaults.standard.object(forKey:"lastUpdate") == nil {
                    UserDefaults.standard.set(jsonLastUpdate, forKey:"lastUpdate")
                }
                // Connecting to the server through provided dbURL with lastUpdate query
                URLSession.shared.dataTask(with: URL(string: ("\(dbURL.absoluteString)?lastUpdate=\(String(describing: UserDefaults.standard.object(forKey: "lastUpdate")!))").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) { (data, response, err) in
                    
                    // Receiving data from the server
                    guard let data = data else { return }
                    
                    do{
                        // Decoding info from database and storing it in the structure nessDatabase
                        self.nessDatabase = try JSONDecoder().decode(NessDatabase.self, from: data)
                        //print(self.nessDatabase!)
                    } catch let jsonErr{
                        print("Error serialising JSON: ", jsonErr)
                    }
                    
                    // Creating Mirror reflecting nessDatabase (updates received from Database)
                    let databaseMirror = Mirror(reflecting: self.nessDatabase!)
                    
                    // Accessing properties of the nessDatabase structure
                    for (dbTableName, tableContent) in databaseMirror.children {
                        print("TO UPDATE--> \(dbTableName!): \(tableContent) \n")
                        
                        var entity: NSManagedObject?
                        var request: NSFetchRequest<NSFetchRequestResult>?
                        
                        // Table property used to identify unique row
                        var idProperty: String?
                        
                        // For each row in table (tableContent) of (dbTableName)
                        for row in tableContent as! [Any] {
                            
                            // Create Mirror of the row which is a structure of particular table
                            let rowMirror = Mirror(reflecting: row)
                            print("updating row--> \(dbTableName!): \(row) \n")
                            
                            // Check which table is being currently read in order to create corresponding Entity
                            switch (dbTableName!) {
                            case "attractions":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Attractions")
                                idProperty = "id"
                                entity = Attractions(context: context)
                            case "bed":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beds")
                                idProperty = "bed_id"
                                entity = Beds(context: context)
                            case "features":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Features")
                                idProperty = "id"
                                entity = Features(context: context)
                            case "garden_sections":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Garden_sections")
                                idProperty = "id"
                                entity = Garden_sections(context: context)
                            case "images":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
                                idProperty = "recnum"
                                entity = Images(context: context)
                            case "itf2":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Itf2")
                                idProperty = "recnum"
                                entity = Itf2(context: context)
                            case "trail_locations":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trail_locations")
                                idProperty = "id"
                                entity = Trail_locations(context: context)
                            case "trail_points":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trail_points")
                                idProperty = "id"
                                entity = Trail_points(context: context)
                            case "trails":
                                request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trails")
                                idProperty = "id"
                                entity = Trails(context: context)
                            default: print("dbTableName didn't match any cases! "); break
                            }
                            
                            
                            // We take one row from the table and we break it down to property and content
                            for (tableProperty, content) in rowMirror.children {
                                print("checking--> \(tableProperty!)= \(self.unwrap(any: content))  for idProperty:\(idProperty!) \n")
                                // if property of updated row == identification property
                                if (tableProperty == idProperty!) {
                                    // then request from Core Data only entities with id == as content (one from update url)
                                    request!.predicate = NSPredicate(format: "%K == %@", idProperty!, self.unwrap(any: content) as! String)
                                    
                                    print(String(format:"FETCHING REQ WITH PREDICATE: %K == %@",idProperty!, self.unwrap(any: content) as! String))
                                    
                                    request!.returnsObjectsAsFaults = false
                                    // delete returned object
                                    do{
                                        let result = try context.fetch(request!)
                                        print("Result from fetching request: \(result) \n")
                                        for object in result {
                                            context.delete(object as! NSManagedObject)
                                            print("deleting: \(object) \n")
                                        }
                                        try context.save()
                                    } catch {
                                        print("Failed saving context after deleting entity")
                                    }
                                    print("ADDING NEW ENTITY: ")
                                    
                                    // Check whether enabled is 1 then we add new entity
                                    if String(describing: self.unwrap(any: rowMirror.descendant("enabled")! as Any)) == "1" {
                                        
                                        for (tableProperty2, content2) in rowMirror.children {
                                            entity?.setValue(content2 as? String, forKey: tableProperty2!)
                                            print("\(tableProperty2!)= \(content2) \n")
                                        }
                                        print("Entity to be saved:  \(entity!)")
                                        // if enabled is 0 then we don't add new entity and delete created one
                                    } else if String(describing: self.unwrap(any: rowMirror.descendant("enabled")! as Any)) == "0" {
                                        context.delete(entity!)
                                    }
                                    
                                    break   // exit the loop because we don't need to check other tableProperty
                                }
                            }
                            do {
                                try context.save()
                            } catch {
                                print("Failed saving context after update")
                            }
                        }
                    }
                    
                    completionHandler() // dataProcessing completed
                    
                }.resume()
            }

    }
    

    
    // Function for unwrapping optional values from Mirror.children
    //      taken from: https://stackoverflow.com/a/32516815/10354480
    func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    

}
