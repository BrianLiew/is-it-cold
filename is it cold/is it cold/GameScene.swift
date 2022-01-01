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
        let rain_node = SKSpriteNode(color: UIColor(red: 1, green: 1, blue: 1, alpha: 1), size: CGSize(width: 2, height: 30))
        rain_node.position = CGPoint(x: random(from: -screen_width / 2, to: screen_width / 2), y: screen_height)
        
        addChild(rain_node)
        
        let movement = SKAction.move(by: CGVector(dx: 0, dy: -screen_height * 2), duration: 1.0)
        let removal = SKAction.removeFromParent()
        
        rain_node.run(SKAction.sequence([movement, removal]))
    }
    
    func random(from: Double, to: Double) -> Double { return Double.random(in: (from...to))}
}
