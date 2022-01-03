//
//  GameScene.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(rain),
            SKAction.wait(forDuration: 0.025)
        ])))
    }
    
    func rain() -> Void {        
        let rain_node = SKSpriteNode(color: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), size: CGSize(width: 2, height: 30))
        rain_node.position = CGPoint(x: random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(rain_node)
        
        let movement = SKAction.move(by: CGVector(dx: 0, dy: -screen_height * 2), duration: 1.0)
        let removal = SKAction.removeFromParent()
        
        rain_node.run(SKAction.sequence([movement, removal]))
    }
    
    func random(from: Double, to: Double) -> Double { return Double.random(in: (from...to))}
}

/*
// UIImage extension for generating gradient backgrounds
extension UIImage {
    
    static func generate_gradient(bounds: CGRect, start: CGPoint, end: CGPoint, colors: [UIColor]) -> UIImage {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.colors = colors
        
        UIGraphicsBeginImageContext(bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

var background_image = UIImage()

background_image = UIImage.generate_gradient(bounds: self.view!.bounds, start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1), colors: [ UIColor(displayP3Red: 0, green: 0.2, blue: 0.4, alpha: 1.0),
    UIColor(displayP3Red: 0, green: 0.77, blue: 1, alpha: 1.0)
])

let gradient_texture = SKTexture(image: background_image)
let background = SKSpriteNode(texture: gradient_texture)
addChild(background)

*/
