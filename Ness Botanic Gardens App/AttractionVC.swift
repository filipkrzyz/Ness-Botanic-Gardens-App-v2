//
//  AttractionVC.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 05/03/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class AttractionVC: UIViewController {

    var entityName: String!
    var idProperty: String!
    var idValue: String!
    var attraction: Attractions?
    var imgName: String = ""
    var imageView = UIImageView()
 
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var constraint: NSLayoutConstraint
        
        // Referencing AppDelegate because it has some functions neccessary for using Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // context gives us access to use Core Data
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", idProperty!, idValue!)
        //print("idProperty: \(idProperty!), idValue: \(idValue!)")
        do{
            // Fetch results of the request into result
            let result = try context.fetch(request)
            for attraction in result {
                self.attraction = attraction as? Attractions
            }
            
            
            if self.attraction?.symbol_name != nil {
                //Image View
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                self.imageView.contentMode = .scaleAspectFit
//                self.imageView.layer.masksToBounds = true
//                self.imageView.layer.borderWidth = 3
//                self.imageView.layer.borderColor = sunriseGold.cgColor
                self.imageView.image = UIImage(named: self.attraction!.symbol_name!)
                if self.imageView.image != nil {
                    stackView.addArrangedSubview(self.imageView)
                    constraint = imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true
                    
                    constraint = imageView.widthAnchor.constraint(equalTo: view.widthAnchor)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true

                }
                
            }
            
            //Title Label
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            textLabel.textColor = atlanticBlue
            textLabel.text  = self.attraction!.attraction_name!
            textLabel.textAlignment = .left
            textLabel.font = UIFont.boldSystemFont(ofSize: 25)
            
            
            stackView.addArrangedSubview(textLabel)
            constraint = textLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            //Description TextView
            let descriptionView = UITextView()
            descriptionView.textColor = graphiteGrey
            descriptionView.text  = self.attraction!.descript!
            descriptionView.textAlignment = .left
            descriptionView.sizeToFit()
            descriptionView.font = UIFont.systemFont(ofSize: 22)
            descriptionView.isScrollEnabled = false
            descriptionView.isEditable = false

            
            stackView.addArrangedSubview(descriptionView)
            constraint = descriptionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = descriptionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
        } catch {
            print("Failed fetching results of the request and processing Core Data")
        }
        
    }

}
