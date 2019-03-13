//
//  SectionViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 18/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class SectionViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var entityName: String!
    var idProperty: String!
    var idValue: String!
    var section: Garden_sections?
    
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
        print("idProperty: \(idProperty!), idValue: \(idValue!)")
        do{
            // Fetch results of the request into result
            let result = try context.fetch(request)
            for section in result {
                self.section = section as? Garden_sections
            }
            
            
            //Title Label
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            textLabel.textColor = atlanticBlue
            textLabel.text  = self.section!.name!
            textLabel.textAlignment = .left
            textLabel.font = UIFont.boldSystemFont(ofSize: 25)
            
            stackView.addArrangedSubview(textLabel)
            constraint = textLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            //Description TextView
            let descriptionView = UITextView()
            descriptionView.textColor = graphiteGrey
            descriptionView.text  = self.section!.descript!
            descriptionView.textAlignment = .justified
            descriptionView.sizeToFit()
            descriptionView.font = UIFont.systemFont(ofSize: 22)
            descriptionView.isScrollEnabled = false
            descriptionView.isEditable = false
            
            stackView.addArrangedSubview(descriptionView)
            constraint = descriptionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = descriptionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let imgNames = [self.section!.image_name1, self.section!.image_name2, self.section!.image_name3, self.section!.image_name4, self.section!.image_name5]
            
            for image in imgNames {
                if image != nil && image != "" {
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(named: image!)
                    
                    stackView.addArrangedSubview(imageView)
                    constraint = imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true
                    
                    constraint = imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true
                }
            }
            
        } catch {
            print("Failed fetching results of the request and processing Core Data")
        }
    }
    

    

}
