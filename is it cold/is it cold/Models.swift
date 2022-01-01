//
//  Models.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

struct weather_data: Codable {
    var name: String
    var main: main
    var sys: sys
    var wind: wind
    var weather: [Weather]
    
    func return_description() -> String { return weather[0].description }
    func return_icon() -> String { return weather[0].icon }
}

struct main: Codable {
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}

struct sys: Codable {
    var country: String
}

struct wind: Codable {
    var deg: Int
    var speed: Double
}

struct Weather: Codable {
    var description: String
    var icon: String
}
