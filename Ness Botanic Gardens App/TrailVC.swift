//
//  TrailVC.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 23/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit

class TrailVC: UIViewController {
    
    var trail: Trail!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var trailNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var formattedString = NSMutableAttributedString()
        
        formattedString = NSMutableAttributedString(string: "\(self.trail.trail_name ?? "") \n", attributes: header1)
        trailNameLabel.attributedText = formattedString
        
        formattedString = NSMutableAttributedString(string: "\(self.trail.descript ?? "") \n", attributes: bodyText)
        formattedString.append(NSAttributedString(string: "Duration ", attributes: header2))
        formattedString.append(NSAttributedString(string: "\(self.trail.duration ?? "") \n", attributes: bodyText))
        formattedString.append(NSAttributedString(string: "Distance ", attributes: header2))
        formattedString.append(NSAttributedString(string: "\(self.trail.distance ?? "") \n", attributes: bodyText))
        formattedString.append(NSAttributedString(string: "\(self.trail.difficulty ?? "") \n", attributes: bodyText))
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        formattedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: formattedString.length))
        
        DispatchQueue.main.async { [weak self] in
            self?.textView.attributedText = formattedString
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailMapSegue" {
            guard let trailMapVC = segue.destination as? TrailMapVC else { return  }
            trailMapVC.trail = self.trail
        }
    }
}


