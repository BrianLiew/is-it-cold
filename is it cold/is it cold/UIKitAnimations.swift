//
//  UIKitAnimations.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation
import UIKit

private let pi: Double = 3.1415

// clear sky
func clear_sky(view: UIView) -> Void {
    // graphics
    let background = CAGradientLayer()
    background.frame = view.bounds
    background.colors = [
        UIColor(displayP3Red: 0, green: 0.77, blue: 1, alpha: 0).cgColor,
        UIColor(displayP3Red: 0, green: 0.77, blue: 1, alpha: 1.0).cgColor
    ]
    
    view.layer.addSublayer(background)
    
    let path = UIBezierPath(arcCenter: CGPoint(x: screen_width / 2, y: screen_height / 2), radius: 150, startAngle: 0, endAngle: (CGFloat)(3.14 * 2), clockwise: true)
    let path_2 = UIBezierPath(arcCenter: CGPoint(x: screen_width / 2, y: screen_height / 2), radius: 185, startAngle: 0, endAngle: (CGFloat)(3.14 * 2), clockwise: true)
    let layer = CAShapeLayer()
    let layer_2 = CAShapeLayer()
    layer.path = path.cgPath
    layer_2.path = path_2.cgPath
    
    layer.position = CGPoint(x: 200, y: -screen_height / 2)
    layer.fillColor = UIColor(red: 1, green: 0.96, blue: 0.65, alpha: 1).cgColor
    layer_2.position = CGPoint(x: 200, y: -screen_height / 2)
    layer_2.fillColor = UIColor(red: 1, green: 0.96, blue: 0.65, alpha: 0.15).cgColor
    
    // animation
    let animation = CABasicAnimation()
    
    animation.keyPath = "position.x"
    animation.fromValue = layer.position.x
    animation.toValue = layer.position.x - 100
    animation.duration = 2.0
    
    layer.add(animation, forKey: nil)
    layer.position.x = layer.position.x - 100
    
    layer_2.add(animation, forKey: nil)
    layer_2.position.x = layer_2.position.x - 100
    
    animation.keyPath = "position.y"
    animation.fromValue = layer.position.y
    animation.toValue = layer.position.y + 100
    animation.duration = 2.0
    
    layer.add(animation, forKey: nil)
    layer.position.y = layer.position.y + 100
    
    layer_2.add(animation, forKey: nil)
    layer_2.position.y = layer_2.position.y + 100
    
    view.layer.addSublayer(layer)
    view.layer.addSublayer(layer_2)
}
