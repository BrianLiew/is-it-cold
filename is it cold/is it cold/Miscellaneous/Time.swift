//
//  Time.swift
//  is it cold
//
//  Created by Brian Liew on 1/19/22.
//

import Foundation

func timeFormatter(current_time: Double) -> String {
    let time = Date(timeIntervalSince1970: current_time)

    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "hh:mm a"
    let time_string = format.string(from: time)
    
    return time_string
}

func dateFormatter(current_time: Double) -> String {
    let date = Date(timeIntervalSince1970: current_time)

    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "E MMM DD"
    let date_string = format.string(from: date)
    
    return date_string
}

func getCurrentTime() -> String {
    let date = Date()
    
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "hh:mm:ss a"
    let time_string = format.string(from: date)
 
    return time_string
}

// for dynamic animations based on time of day
/*
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

*/
