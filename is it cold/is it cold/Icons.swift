//
//  Icons.swift
//  is it cold
//
//  Created by Brian Liew on 1/8/22.
//

import Foundation
import UIKit

class Icons {
    
    var icon: UIImage = UIImage()
    var description: String = ""
    
    init(icon: UIImage?, description: String) {
        if let icon_unwrapped = icon { self.icon = icon_unwrapped }
        self.description = description
    }
    
}
