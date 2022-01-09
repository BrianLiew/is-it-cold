//
//  AllData.swift
//  is it cold
//
//  Created by Brian Liew on 1/8/22.
//

import Foundation

class AllData {
    
    static let instance = AllData()
    
    var latitude: Double = 00.00
    var longitude: Double = 00.00
    
    func get_latitude() -> Double { return latitude }
    func get_longitude() -> Double { return longitude }
    
    func set_latitude(value: Double) -> Void { latitude = value }
    func set_longitude(value: Double) -> Void { longitude = value }
    
}
