//
//  CustomMarker.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 16/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation
import GoogleMaps

class CustomMarker: GMSMarker {
    
    var label: UILabel!
    
    init(labelText: String) {
        super.init()
        
        label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 80)))
        
        label.text = labelText
        label.textColor = atlanticBlue
        label.contentMode = .scaleToFill
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        self.iconView = label
    }
}
