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
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ButtonThemer
import MaterialComponents.MDCContainedButtonThemer



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
    
    var filterDict: [String: Bool] = ["featuresCheckbox": true, "attractionsCheckbox": true,"sectionsCheckbox": true, "bedsCheckbox": true]
    
    @IBOutlet var filterPopover: UIView!
    @IBOutlet var grayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        // Create camera looking at Ness Gardens
        self.camera = GMSCameraPosition.camera(withLatitude: 53.272522, longitude: -3.042988, zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: view.layoutMarginsGuide.layoutFrame, camera: camera)
        
        // Seting compass graphic and myLocationButton which appears on the map
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.tiltGestures = false
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        //view = mapView
        view.addSubview(mapView)
        //mapView.translatesAutoresizingMaskIntoConstraints = false
        //mapView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 15).isActive = true
        
        
        
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

        // NESS BUTTON
        let buttonScheme = MDCButtonScheme()
        let nessButton = MDCFloatingButton()
        nessButton.setImage(UIImage(named: "NessLogoCircle.png")!, for: .normal)
        MDCFloatingActionButtonThemer.applyScheme(buttonScheme, to: nessButton)
        //nessButton.frame = CGRect(x:self.view.frame.maxX - 66, y:self.mapView.frame.maxY - 185, width:60,height:60)
        nessButton.setElevation(ShadowElevation(rawValue: 1), for: .normal)
        nessButton.setElevation(ShadowElevation(rawValue: 4), for: .highlighted)
        view.addSubview(nessButton)
        nessButton.translatesAutoresizingMaskIntoConstraints = false
        nessButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nessButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nessButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -75).isActive = true
        nessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nessButton.addTarget(self, action: #selector(self.nessButtonPressed), for: .touchUpInside)
        nessButton.setBorderColor(UIColor.white, for: .normal)
        nessButton.setBorderWidth(0.0, for: .normal)
        
        // FILTER BUTTON
        let filterButton = MDCButton()
        MDCContainedButtonThemer.applyScheme(buttonScheme, to: filterButton)
        //filterButton.frame = CGRect(x:mapView.frame.midX - 60, y:mapView.frame.maxY - 105, width:120,height:40)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.setTitleColor(graphiteGrey, for: .normal)
        filterButton.setBackgroundColor(UIColor.white, for: .normal)
        filterButton.setTitleColor(UIColor.white, for: .highlighted)
        filterButton.setBackgroundColor(graphiteGrey, for: .highlighted)
        filterButton.setElevation(ShadowElevation(rawValue: 2), for: .normal)
        filterButton.setElevation(ShadowElevation(rawValue: 4), for: .highlighted)
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        filterButton.addTarget(self, action: #selector(self.filterButtonPressed), for: .touchUpInside)
        
        
    }   // <-- viewDidLoad()
    
    @objc func nessButtonPressed() {
        print("ness button pressed")
        self.camera = GMSCameraPosition.camera(withLatitude: 53.272522, longitude: -3.042988, zoom: 15.0)
        self.mapView.animate(to: self.camera)
    }
    
    @objc func filterButtonPressed() {
        print("filter button pressed")
        self.view.addSubview(self.grayView)
        self.grayView.frame = self.view.frame
        //self.grayView.center = self.view.center
        self.view.addSubview(self.filterPopover)
        self.filterPopover.center = self.view.center
    }
    
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        print(sender.accessibilityIdentifier ?? "Identifier")
        if sender.isSelected {
            sender.isSelected = false
            self.filterDict[sender.accessibilityIdentifier!] = false
        } else {
            sender.isSelected = true
            self.filterDict[sender.accessibilityIdentifier!] = true
        }
        print(self.filterDict)
    }
    
    @IBAction func submitFilter(_ sender: Any) {
        self.filterPopover.removeFromSuperview()
        self.grayView.removeFromSuperview()
        self.showMarkers(mapView: mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
       
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
                if mapView.camera.zoom >= 18 && self.filterDict["bedsCheckbox"] == true {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Attractions":
                if mapView.camera.zoom >= 16 && self.filterDict["attractionsCheckbox"] == true {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Features":
                if mapView.camera.zoom >= 15 && self.filterDict["featuresCheckbox"] == true {
                    self.markersMutableDict[id]?.marker?.map = mapView
                } else {
                    self.markersMutableDict[id]?.marker?.map = nil
                }
            case "Garden_sections":
                if mapView.camera.zoom >= 16 && self.filterDict["sectionsCheckbox"] == true {
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

