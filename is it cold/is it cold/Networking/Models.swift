//
//  Models.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

// MARK: CURRENT WEATHER data or current_url only
/*
struct weather_data: Codable {
    var name: String
    var main: main
    var sys: sys
    var wind: wind
    var weather: [Weather]
    
    func return_description() -> String { return weather[0].description }
    func return_icon() -> String { return weather[0].icon }
    
    // for debug use only
    mutating func set_description(description: String) -> Void { weather[0].description = description }
}

struct main: Codable {
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}

struct wind: Codable {
    var deg: Int
    var speed: Double
}

struct Weather: Codable {
    var description: String
    var icon: String
}

struct sys: Codable {
    var country: String
}
 */

// MARK: ONE CALL WEATHER data or one_url only
struct weather_data: Codable {
    var current: current
    var hourly: [Hourly]
    
    func return_description() -> String { return current.weather[0].description }
    func return_image_string(index: Int) -> String { return hourly[index].weather[0].icon }
    // for debug use only
    mutating func set_description(description: String) -> Void { current.weather[0].description = description }
}

struct current: Codable {
    var temp: Double
    var weather: [Weather]
}

struct Hourly: Codable {
    var dt: Double
    var temp: Double
    var wind_speed: Double
    var weather: [Weather]
}

struct Weather: Codable {
    var description: String
    var icon: String
}
