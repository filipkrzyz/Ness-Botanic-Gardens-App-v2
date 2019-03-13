//
//  MapViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 02/01/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    // Referencing AppDelegate because it has some functions neccessary for using Core Data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var markersList: [Marker] = []
    //var markersDictionary: Dictionary<Int, Marker>?
    var markersMutableDict: [Int: Marker] = [:]
    
    var selectedMarker: Marker?
    
    var mapView = GMSMapView()
    var camera = GMSCameraPosition()
    var locationManager = CLLocationManager()
    
    var nextMarkerID: Int = 0  // markerID
    
    var nessButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        // Create camera looking at Ness Gardens
        self.camera = GMSCameraPosition.camera(withLatitude: 53.272522, longitude: -3.042988, zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Seting compass graphic and myLocationButton which appears on the map
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.tiltGestures = false
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view = mapView
        
        
        
        ////// Setting up Ness Gardens map image ground overlay
        let southWest = CLLocationCoordinate2D(latitude: 53.26862390, longitude: -3.05009044)
        let northEast = CLLocationCoordinate2D(latitude: 53.27512120, longitude: -3.04006972)
        
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
       
        let icon = UIImage(named: "mapOriginal")
        
        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.bearing = 0
        //overlay.opacity = 0.3
        overlay.map = mapView
        ////////////////////////////////
        
        // retrieve markers from Core Data and wait for completion handler
        retrieveMarkers {
            // Create GMSMarker object for each marker in the dictionary
            self.createMarkers {
                // Display markers in the mapView
                self.showMarkers(mapView: self.mapView)
            }
        }
        
        

        
    }   // <-- viewDidLoad()
    
    @objc func nessButtonPressed() {
        print("ness button pressed")
        self.camera = GMSCameraPosition.camera(withLatitude: 53.272522, longitude: -3.042988, zoom: 15.0)
        self.mapView.animate(to: self.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // NESS BUTTON
        self.nessButton = UIButton(type: .custom)
        self.nessButton.translatesAutoresizingMaskIntoConstraints = false
        self.nessButton.backgroundColor = UIColor.white
        self.nessButton.setImage(UIImage(named:"NessLogoCircle.png"), for: .normal)
        self.nessButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        self.nessButton.addTarget(self, action: #selector(self.nessButtonPressed), for: .touchUpInside)
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.nessButton)
                //self.nessButton.trailingAnchor.constraint(equalTo: self.nessButton.trailingAnchor, constant: 10).isActive = true
                //self.nessButton.bottomAnchor.constraint(equalTo: self.nessButton.bottomAnchor, constant: 100).isActive = true
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.nessButton.trailingAnchor, constant: 10),
                    keyWindow.bottomAnchor.constraint(equalTo: self.nessButton.bottomAnchor, constant: 120),
                    self.nessButton.widthAnchor.constraint(equalToConstant: 56),
                    self.nessButton.heightAnchor.constraint(equalToConstant: 56)])
            }
            
            self.nessButton.layer.cornerRadius = 30.0
            self.nessButton.layer.shadowColor = graphiteGrey.cgColor
            self.nessButton.layer.shadowOffset = CGSize(width: 0, height: 25)
            self.nessButton.layer.shadowRadius = 30.0
            self.nessButton.layer.shadowOpacity = 0.25
            self.nessButton.clipsToBounds = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if self.nessButton.superview != nil {
            DispatchQueue.main.async {
                self.nessButton.removeFromSuperview()
                self.nessButton = UIButton()
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.showMarkers(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // userData holds all the information about the marker
        self.selectedMarker = marker.userData as? Marker
        if self.selectedMarker!.entityName! == "Attractions" {
            performSegue(withIdentifier: "attractionSegue", sender: self)
        } else if self.selectedMarker!.entityName! == "Beds" {
            performSegue(withIdentifier: "bedSegue", sender: self)
        } else if self.selectedMarker!.entityName! == "Garden_sections" {
            performSegue(withIdentifier: "sectionSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "attractionSegue" {
            guard let attractionVC = segue.destination as? AttractionVC else { return  }
            attractionVC.entityName = self.selectedMarker!.entityName!
            attractionVC.idProperty = self.selectedMarker!.idProperty!
            attractionVC.idValue = self.selectedMarker!.idValue!
        }else if segue.identifier == "sectionSegue" {
            guard let sectionVC = segue.destination as? SectionViewController else { return  }
            sectionVC.entityName = self.selectedMarker!.entityName!
            sectionVC.idProperty = self.selectedMarker!.idProperty!
            sectionVC.idValue = self.selectedMarker!.idValue!
        }
        else if segue.identifier == "bedSegue" {
            guard let bedVC = segue.destination as? BedViewController else { return  }
            bedVC.bedID = self.selectedMarker!.idValue!
            bedVC.sectionName = self.selectedMarker!.title!
            
        }
        
    }
    
    func showMarkers(mapView: GMSMapView) {
        
        for (id, marker) in self.markersMutableDict {
            
            // Making sure correct markers display on correct zoom level, otherwise are hidden
            
            switch (marker.entityName) {
            case "Beds":
                if mapView.camera.zoom >= 18 {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Attractions":
                if mapView.camera.zoom >= 16 {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Features":
                if mapView.camera.zoom >= 15 {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Garden_sections":
                if mapView.camera.zoom >= 16 {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Trail_points":
                if mapView.camera.zoom >= 16 {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            default:
                self.markersMutableDict[id]?.marker?.map = nil
            }
        }
    }
    
    func retrieveMarkers(completionHandler: @escaping() -> Void) {
        
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Attractions")
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                //print("Attraction result: ",result)
                for entity in result as! [NSManagedObject] {
                    self.markersList.append(Marker(
                        markerID: self.nextMarkerID,
                        title: entity.value(forKey: "attraction_name") as? String,
                        snippet: "Tap here to see more details...",
                        description: entity.value(forKey: "descript") as? String,
                        latitude: entity.value(forKey: "latitude") as? String,
                        longitude: entity.value(forKey: "longitude") as? String,
                        icon: "attraction",
                        entityName: "Attractions",
                        idProperty: "id",
                        idValue: entity.value(forKey: "id") as? String,
                        marker: nil))
                    self.nextMarkerID = self.nextMarkerID + 1
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
           
            
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Features")
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                //print("Feature result: ",result)
                for entity in result as! [NSManagedObject] {
                    self.markersList.append(Marker(
                        markerID: self.nextMarkerID,
                        title: entity.value(forKey: "name") as? String,
                        snippet: nil,
                        description: nil,
                        latitude: entity.value(forKey: "latitude") as? String,
                        longitude: entity.value(forKey: "longitude") as? String,
                        icon: entity.value(forKey: "image_name") as? String,
                        entityName: "Features",
                        idProperty: "id",
                        idValue: entity.value(forKey: "id") as? String,
                        marker: nil ))
                    self.nextMarkerID = self.nextMarkerID + 1
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Garden_sections")
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                //print("Sections result: ",result)
                for entity in result as! [NSManagedObject] {
                    self.markersList.append(Marker(
                        markerID: self.nextMarkerID,
                        title: entity.value(forKey: "name") as? String,
                        snippet: "Tap here to see more details...",
                        description: entity.value(forKey: "descript") as? String,
                        latitude: entity.value(forKey: "latitude") as? String,
                        longitude: entity.value(forKey: "longitude") as? String,
                        icon: nil,
                        entityName: "Garden_sections",
                        idProperty: "id",
                        idValue: entity.value(forKey: "id") as? String,
                        marker: nil ))
                    self.nextMarkerID = self.nextMarkerID + 1
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Beds")
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                //print("beds result: ",result)
                for entity in result as! [NSManagedObject] {
                    self.markersList.append(Marker(
                        markerID: self.nextMarkerID,
                        title: "\(String(describing: entity.value(forKey: "bed_id")! as! String)): \(String(describing: entity.value(forKey: "section_name")! as! String))",
                        snippet: "Tap here to see more details...",
                        description: nil,
                        latitude: entity.value(forKey: "latitude") as? String,
                        longitude: entity.value(forKey: "longitude") as? String,
                        icon: "bed",
                        entityName: "Beds",
                        idProperty: "bed_id",
                        idValue: entity.value(forKey: "bed_id") as? String,
                        marker: nil ))
                    self.nextMarkerID = self.nextMarkerID + 1
                }
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            DispatchQueue.main.sync {  [unowned self] in
                self.markersMutableDict = Dictionary(uniqueKeysWithValues: self.markersList.lazy.map { ($0.markerID, $0) })
            }
            
            completionHandler()
        }
    }
    
    func createMarkers(completionHandler: @escaping() -> Void) {
        
        DispatchQueue.main.async {  [unowned self] in
            
            // For all markers in the dictionary create GMSMarker ans save in dictionary
            for (id, marker) in self.markersMutableDict {
                
                var markerPoint: GMSMarker
                if marker.entityName == "Garden_sections" {
                    markerPoint = CustomMarker(labelText: marker.title!)
                } else {
                    markerPoint = GMSMarker()
                }
                
                let coordinates = CLLocationCoordinate2D(latitude: Double(marker.latitude!)!, longitude: Double(marker.longitude!)!)
                markerPoint.position = coordinates
                markerPoint.title = marker.title
                markerPoint.snippet = marker.snippet
                if marker.icon != nil { markerPoint.icon = UIImage(named: marker.icon!) }
                // Saving Marker details in userData so it can be retrieved when marker is tapped
                markerPoint.userData = marker
                self.markersMutableDict[id]?.marker = markerPoint
            }
            completionHandler()
        }
    }
    
}

