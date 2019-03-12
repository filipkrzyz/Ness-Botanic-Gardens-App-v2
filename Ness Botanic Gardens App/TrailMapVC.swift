//
//  TrailMapVC.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 23/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class TrailMapVC: MapViewController {
    
    //var trailPoints: [TrailPoint] = []
    var trail: Trail!
    
    var message: String!
    
    let path = GMSMutablePath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveLocations {
            DispatchQueue.main.async {  [unowned self] in
                let trail = GMSPolyline(path: self.path)
                trail.strokeWidth = 3
                trail.strokeColor = atlanticBlue
                trail.geodesic = true
                trail.map = self.mapView
            }
        }

    }

    override func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        super.mapView(mapView, didTapInfoWindowOf: marker)
        // userData holds all the information about the marker
        self.selectedMarker = marker.userData as? Marker
        if self.selectedMarker!.entityName! == "Trail_points" {
            performSegue(withIdentifier: "pointSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "pointSegue" {
            guard let pointVC = segue.destination as? PointVC else { return  }
            pointVC.entityName = self.selectedMarker!.entityName!
            pointVC.idProperty = self.selectedMarker!.idProperty!
            pointVC.idValue = self.selectedMarker!.idValue!
        }
    }
    
    // Retrieve locations (coordinates for path polyline) from Trail_locations in Core Data
    func retrieveLocations(completionHandler: @escaping() -> Void) {
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trail_locations")
            request.predicate = NSPredicate(format: "%K = %@", "trail_id", self.trail.id!)
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                for trail in result as! [Trail_locations] {
                    self.path.add(CLLocationCoordinate2D(latitude: Double(trail.latitude!)!, longitude: Double(trail.longitude!)!))
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            completionHandler()
        }
    }
    
    override func retrieveMarkers(completionHandler: @escaping () -> Void) {
        
        super.retrieveMarkers {
            self.appDelegate.persistentContainer.performBackgroundTask { (context) in
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trail_points")
                request.predicate = NSPredicate(format: "%K = %@", "trail_id", self.trail.id!)
                request.returnsObjectsAsFaults = false
                do {
                    // Fetch results of the request into result
                    let result = try context.fetch(request)
                    for point in result as! [Trail_points] {
                        self.markersMutableDict[self.nextMarkerID] = Marker(
                            markerID: self.nextMarkerID,
                            title: point.name,
                            snippet: "Tap here to see more details...",
                            description: point.descript,
                            latitude: point.latitude,
                            longitude: point.longitude,
                            icon: "trail_point.png",
                            entityName: "Trail_points",
                            idProperty: "id",
                            idValue: point.id,
                            marker: nil )
                        self.nextMarkerID = self.nextMarkerID + 1
                    }
                } catch {
                    print("Failed fetching results of the request and processing Core Data")
                }
                
                completionHandler()
            }
        }
        
    }
}
