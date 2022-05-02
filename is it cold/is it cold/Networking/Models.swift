import Foundation

struct weather_data: Codable {
    var current: current
    var hourly: [Hourly]
    var daily: [Daily]
    
    // for debug use only
    mutating func set_description(description: String) -> Void { current.weather[0].main = description }
}

struct current: Codable {
    var dt: Int
    var temp: Double
    var weather: [Weather]
}

struct Hourly: Codable {
    var dt: Int
    var temp: Double
    var wind_speed: Double
    var wind_deg: Int
    var weather: [Weather]
}

struct Daily: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var moonrise: Int
    var moonset: Int
    var temp: temp
    var weather: [Weather]
}

struct temp: Codable {
    var min: Double
    var max: Double
}

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
}
