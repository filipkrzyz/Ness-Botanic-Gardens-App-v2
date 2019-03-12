//
//  PointVC.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 24/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData

class PointVC: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var entityName: String!
    var idProperty: String!
    var idValue: String!
    var point: Trail_points?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var constraint: NSLayoutConstraint
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", idProperty!, idValue!)
        print("idProperty: \(idProperty!), idValue: \(idValue!)")
        do{
            // Fetch results of the request into result
            let result = try context.fetch(request)
            for point in result {
                self.point = point as? Trail_points
            }
            
            //Title Label
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            textLabel.textColor = atlanticBlue
            textLabel.text  = self.point!.name ?? "Trail Point"
            textLabel.textAlignment = .left
            textLabel.font = UIFont.boldSystemFont(ofSize: 25)
            
            stackView.addArrangedSubview(textLabel)
            constraint = textLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 7
            
            //Description TextView
            let descriptionView = UITextView()
            descriptionView.textColor = graphiteGrey
            descriptionView.typingAttributes = [NSAttributedString.Key.paragraphStyle: style]
            descriptionView.text  = self.point!.descript ?? "No description"
            descriptionView.textAlignment = .justified
            descriptionView.sizeToFit()
            descriptionView.font = UIFont.systemFont(ofSize: 22)
            descriptionView.isScrollEnabled = false
            
            stackView.addArrangedSubview(descriptionView)
            constraint = descriptionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            constraint = descriptionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
            constraint.priority = UILayoutPriority(999)
            constraint.isActive = true
            
            stackView.spacing = 5
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            let imgNames = [self.point!.image_name1, self.point!.image_name2, self.point!.image_name3, self.point!.image_name4, self.point!.image_name5]
            
            var firstImage = true
            for image in imgNames {
                if image != nil && image != "" {
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(named: image!)
                    
                    if firstImage { stackView.insertArrangedSubview(imageView, at: 0) }
                    else { stackView.addArrangedSubview(imageView) }
                    
                    constraint = imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true
                    
                    constraint = imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                    constraint.priority = UILayoutPriority(999)
                    constraint.isActive = true
                }
                firstImage = false
            }
            
            
        } catch {
            print("Failed fetching results of the request and processing Core Data")
        }
        
        
    }

}
