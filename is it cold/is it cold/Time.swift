//
//  Time.swift
//  is it cold
//
//  Created by Brian Liew on 1/19/22.
//

import Foundation

class Time {
    
    var current: TimeInterval
    var sunrise: TimeInterval
    var sunset: TimeInterval
    var moonrise: TimeInterval
    var moonset: TimeInterval
    
    init(
        current: TimeInterval,
        sunrise: TimeInterval,
        sunset: TimeInterval,
        moonrise: TimeInterval,
        moonset: TimeInterval
    ) {
        self.current = current
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
    }
    
}
