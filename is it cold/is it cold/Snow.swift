//
//  Snow.swift
//  is it cold
//
//  Created by Brian Liew on 1/4/22.
//

import SpriteKit
import GameplayKit

class Snow: SKScene {
    
    override func didMove(to view: SKView) {
        run(SKAction.group([
            // background
            SKAction.colorize(with: SKColor(displayP3Red: 0, green: 0.25, blue: 0.5, alpha: 0.25), colorBlendFactor: 1.0, duration: 3.0),
            // snow animation
            SKAction.repeatForever(SKAction.sequence([
                SKAction.group([
                    SKAction.run(big_snow),
                    SKAction.wait(forDuration: 0.5)
                ]),
                SKAction.group([
                    SKAction.run(medium_snow),
                    SKAction.wait(forDuration: 0.01)
                ]),
                SKAction.group([
                    SKAction.run(small_snow),
                    SKAction.wait(forDuration: 0.005)
                ])
            ]))
        ]))
    }
    
    func small_snow() -> Void {
        let snow_node = SKSpriteNode(imageNamed: "snowflake")
        snow_node.size = CGSize(width: 30, height: 30)
        snow_node.alpha = 0.3
        snow_node.position = CGPoint(x: random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(snow_node)
        
        let movement = SKAction.move(by: CGVector(dx: random(from: snow_node.position.x - 100, to: snow_node.position.x + 100), dy: -screen_height * 2), duration: 10.0)
        let rotation = SKAction.rotate(byAngle: random(from: -10 * .pi, to: 10 * .pi), duration: TimeInterval.random(in: (20...30)))
        let removal = SKAction.removeFromParent()
        
        snow_node.run(SKAction.sequence([SKAction.group([movement, rotation]), removal]))
    }
    
    func medium_snow() -> Void {
        let snow_node = SKSpriteNode(imageNamed: "snowflake")
        snow_node.size = CGSize(width: 40, height: 40)
        snow_node.alpha = 0.4
        snow_node.position = CGPoint(x: random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(snow_node)
        
        let movement = SKAction.move(by: CGVector(dx: random(from: snow_node.position.x - 100, to: snow_node.position.x + 100), dy: -screen_height * 2), duration: 10.0)
        let rotation = SKAction.rotate(byAngle: random(from: -10 * .pi, to: 10 * .pi), duration: TimeInterval.random(in: (15...20)))
        let removal = SKAction.removeFromParent()
        
        snow_node.run(SKAction.sequence([SKAction.group([movement, rotation]), removal]))
    }
    
    func big_snow() -> Void {
        let snow_node = SKSpriteNode(imageNamed: "snowflake")
        snow_node.size = CGSize(width: 50, height: 50)
        snow_node.alpha = 0.5
        snow_node.position = CGPoint(x: random(from: -screen_width, to: screen_width), y: screen_height)
        
        addChild(snow_node)
        
        let movement = SKAction.move(by: CGVector(dx: random(from: snow_node.position.x - 100, to: snow_node.position.x + 100), dy: -screen_height * 2), duration: 10.0)
        let rotation = SKAction.rotate(byAngle: random(from: -10 * .pi, to: 10 * .pi), duration: TimeInterval.random(in: (10...15)))
        let removal = SKAction.removeFromParent()
        
        snow_node.run(SKAction.sequence([SKAction.group([movement, rotation]), removal]))
    }
        
    func random(from: Double, to: Double) -> Double { return Double.random(in: (from...to))}
    
}
