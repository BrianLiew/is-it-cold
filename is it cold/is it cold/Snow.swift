//
//  Snow.swift
//  is it cold
//
//  Created by Brian Liew on 1/4/22.
//

import SpriteKit
import GameplayKit
import UIKit

class Snow: SKScene {
    
    override func didMove(to view: SKView) {
        run(SKAction.colorize(with: SKColor(displayP3Red: 0, green: 0.25, blue: 0.5, alpha: 0.25), colorBlendFactor: 1.0, duration: 2.0))
    }
    
}
