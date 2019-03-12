//
//  TrailsViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 18/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class TrailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trailsList: [Trail] = []
    
    var selectedTrail: Trail?
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        retrieveTrails {
            DispatchQueue.main.async {  [unowned self] in
                
                self.navigationController?.navigationBar.titleTextAttributes = header1
                
                self.tableView.reloadData()
                
                
            }
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailSegue" {
            guard let trailVC = segue.destination as? TrailVC else { return  }
            trailVC.trail = self.selectedTrail
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTrail = self.trailsList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "trailSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "trailCell")
        
        cell.textLabel?.text = self.trailsList[indexPath.row].trail_name ?? "Trail"
        cell.textLabel?.textColor = atlanticBlue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.detailTextLabel?.text = self.trailsList[indexPath.row].descript ?? ""
        cell.detailTextLabel?.textColor = graphiteGrey
        return cell
    }
    
    
    func retrieveTrails(completionHandler: @escaping() -> Void) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trails")
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                for trail in result as! [Trails] {
                    self.trailsList.append(Trail(
                    id: trail.id,
                    uuid: trail.uuid,
                    trail_name: trail.trail_name,
                    distance: trail.distance,
                    duration: trail.duration,
                    descript: trail.descript,
                    difficulty: trail.difficulty,
                    enabled: trail.enabled,
                    last_update: trail.last_update))
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            
            completionHandler()
        }
        
    }
}
