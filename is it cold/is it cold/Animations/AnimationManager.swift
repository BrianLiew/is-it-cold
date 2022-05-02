import Foundation
import SpriteKit

class AnimationManager {
    
    static func initAnimation(description: String) throws -> Void {
                        
        switch (description) {
        case "Clear":
            Clear.playDayClearSky(view: ViewController.animation_UKView)
        case "Few Clouds":
            ViewController.enableWhiteText()
            Clouds.playClouds(view: ViewController.animation_UKView)
        case "Broken Clouds":
            ViewController.enableWhiteText()
            Clouds.playClouds(view: ViewController.animation_UKView)
        case "Clouds":
            ViewController.enableWhiteText()
            Clouds.playClouds(view: ViewController.animation_UKView)
        case "Shower Rain":
            if let scene = SKScene(fileNamed: "ShowerRain") {
                scene.scaleMode = .aspectFill
                ViewController.enableWhiteText()
                ViewController.animation_SKView.presentScene(scene)
            }
        case "Rain":
            if let scene = SKScene(fileNamed: "Rain") {
                scene.scaleMode = .aspectFill
                ViewController.enableWhiteText()
                ViewController.animation_SKView.presentScene(scene)
            }
        case "Thunderstorm":
            if let scene = SKScene(fileNamed: "Thunderstorm") {
                scene.scaleMode = .aspectFill
                ViewController.enableWhiteText()
                ViewController.animation_SKView.presentScene(scene)
            }
        case "Snow":
            if let scene = SKScene(fileNamed: "Snow") {
                scene.scaleMode = .aspectFill
                ViewController.enableWhiteText()
                ViewController.animation_SKView.presentScene(scene)
            }
        case "Mist":
            if let scene = SKScene(fileNamed: "Mist") {
                scene.scaleMode = .aspectFill
                ViewController.enableWhiteText()
                ViewController.animation_SKView.presentScene(scene)
            }
        default:
            throw AppErrors(description: " AnimationManager.swift initAnimation: description matches no animation case", kind: .AnimationError)
        }
        
        // view.ignoresSiblingOrder = true
        // view.showsFPS = true
        // view.showsNodeCount = true

    }
    
}
