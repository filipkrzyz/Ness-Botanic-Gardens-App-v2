//
//  BedViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 18/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class BedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var plantsList: [InternTransfForm2] = []

    var bedID: String!
    var sectionName: String!
    
    var selectedPlant: InternTransfForm2?
    
    @IBOutlet weak var tableView: UITableView!
    
    // Referencing AppDelegate because it has some functions neccessary for using Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        retrievePlants {
            DispatchQueue.main.async {  [unowned self] in
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantSegue" {
            guard let plantVC = segue.destination as? PlantVC else { return  }
            plantVC.plant = self.selectedPlant
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlant = self.plantsList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "plantSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plantsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "bedCell")
        
        cell.textLabel?.textColor = graphiteGrey
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if self.plantsList[indexPath.row].vernam != nil {
            cell.textLabel?.text = self.plantsList[indexPath.row].vernam! }
        else if self.plantsList[indexPath.row].sp != nil {
            cell.textLabel?.text = self.plantsList[indexPath.row].sp! }
        else if self.plantsList[indexPath.row].fam != nil {
            cell.textLabel?.text = self.plantsList[indexPath.row].fam! }
        else { cell.textLabel?.text = "Plant" }
        
        return cell
    }
    
    func retrievePlants(completionHandler: @escaping() -> Void) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Itf2")
            // Request only those plants that appear in this bed
            request.predicate = NSPredicate(format: "%K CONTAINS %@", "bed", self.bedID)
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                for plant in result as! [Itf2] {
                    // Further check whether this exact bed is location of the plant
                    if (plant.bed!.components(separatedBy: " ")).contains(self.bedID) {
                        
                        self.plantsList.append(InternTransfForm2(
                            recnum: plant.recnum, accsta: plant.accsta,
                            fam: plant.fam, sp: plant.sp, gen: plant.gen, vernam: plant.vernam, cou: plant.cou, latdeg: plant.latdeg, latmin: plant.latmin, latsec: plant.latsec, latdir: plant.latdir, londeg: plant.londeg, lonmin: plant.lonmin, lonsec: plant.lonsec, londir: plant.londir, sgu: plant.sgu, loc: plant.loc, alt: plant.alt, bed: plant.bed, enabled: plant.enabled, last_update: plant.last_update))
                       
                    }
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            
            
            completionHandler()
        }
        
    }

}
