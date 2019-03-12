//
//  PlantVC.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 22/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class PlantVC: UIViewController {

    var plant: InternTransfForm2!
    var image: Images?
    var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        downloadImage {
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold("Family Name: ")
                .normal("\(self.plant.fam ?? "") \n")
                .bold("Species Epithet: ")
                .normal("\(self.plant.sp ?? "") \n")
                .bold("Genus Name: ")
                .normal("\(self.plant.gen ?? "") \n")
                .bold("Common Name: ")
                .normal("\(self.plant.vernam ?? "") \n")
                .bold("Country of origin: ")
                .normal("\(self.plant.cou ?? "") \n")
                .bold("Locality of collection: ")
                .normal("\(self.plant.loc ?? "") \n")
                .bold("Altitude of collection: ")
                .normal("\(self.plant.alt ?? "") \n")
            
            DispatchQueue.main.async { [weak self] in
                let descriptionView = UITextView()
//                descriptionView.allowsEditingTextAttributes = true
//                descriptionView.attributedText.accessibilityActivate()
                descriptionView.attributedText  = formattedString               /// ATTRIBUTED TEXT NOT WORKING
                descriptionView.textAlignment = .left
                descriptionView.sizeToFit()
                descriptionView.font = UIFont.systemFont(ofSize: 22)
                descriptionView.isScrollEnabled = false
                
                
                self!.stackView.addArrangedSubview(descriptionView)
                var constraint = descriptionView.leadingAnchor.constraint(equalTo: self!.stackView.leadingAnchor, constant: 16)
                constraint.priority = UILayoutPriority(rawValue: 999)
                constraint.isActive = true
                constraint.identifier = "descrLeading"
                
                
                constraint = descriptionView.trailingAnchor.constraint(equalTo: self!.stackView.trailingAnchor, constant: -16)
                constraint.priority = UILayoutPriority(rawValue: 999)
                constraint.isActive = true
                constraint.identifier = "descrTrailing"
            }

        }
    }
    
    func downloadImage(completionHandler: @escaping() -> Void) {
        
        appDelegate.persistentContainer.performBackgroundTask { (context) in
            
            var imgFileName: String = ""
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            request.predicate = NSPredicate(format: "%K CONTAINS %@", "recnum", self.plant.recnum!)
            request.returnsObjectsAsFaults = false
            do {
                // Fetch results of the request into result
                let result = try context.fetch(request)
                for entity in result as! [Images] {
                    self.image = entity
                    imgFileName = self.image?.img_file_name! ?? ""
                }
                
            } catch {
                print("Failed fetching results of the request and processing Core Data")
            }
            
            URLSession.shared.dataTask(with: imgURL.appendingPathComponent("\(imgFileName)")) { (data, response, err) in
                guard let data = data else { return }
                
                // Set image in the UI
                DispatchQueue.main.async { [weak self] in
                    self!.imageView.translatesAutoresizingMaskIntoConstraints = false
                    self!.imageView.contentMode = .scaleAspectFit
                    self!.imageView.image = UIImage(data: data)
                    if self!.imageView.image != nil {
                        self!.stackView.insertArrangedSubview(self!.imageView, at: 0)
                        var constraint = self!.imageView.leadingAnchor.constraint(equalTo: self!.scrollView.leadingAnchor, constant: 0)
                        constraint.priority = UILayoutPriority(rawValue: 999)
                        constraint.isActive = true
                        constraint.identifier = "imgLeading"
                        
                        constraint = self!.imageView.trailingAnchor.constraint(equalTo: self!.scrollView.trailingAnchor, constant: 0)
                        constraint.priority = UILayoutPriority(rawValue: 999)
                        constraint.isActive = true
                        constraint.identifier = "imgTrailing"
                        
                        constraint = self!.imageView.heightAnchor.constraint(equalTo: self!.scrollView.heightAnchor, multiplier: 0.5)
                        constraint.priority = UILayoutPriority(rawValue: 999)
                        constraint.isActive = true
                        constraint.identifier = "imgHeight"
                        
                        constraint = self!.imageView.widthAnchor.constraint(equalTo: self!.scrollView.widthAnchor)
                        constraint.priority = UILayoutPriority(rawValue: 999)
                        constraint.isActive = true
                        constraint.identifier = "imgWidth"
                        
                        
                    }
                    
                }
            }.resume()
            
            
            
            completionHandler()
        }
    }
}

// Taken from
// https://stackoverflow.com/a/37992022/10354480
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: atlanticBlue]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: graphiteGrey])
        append(normal)
        
        return self
    }
}

// Taken from https://stackoverflow.com/a/30096600/10354480
//  needed to identify errors with constraints
extension NSLayoutConstraint {
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
