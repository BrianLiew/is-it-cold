import Foundation
import UIKit

struct AllData {
            
    static var city: String = ""
    static var country: String = ""
    
    static var hourly_data: [Hourly] = Array(repeating: Hourly(dt: 0,
                                                        temp: 0,
                                                        wind_speed: 0,
                                                        wind_deg: 0,
                                                        weather: [Weather(main: "", description: "", icon: "")]), count: 24)
    static var daily_data: [Daily] = Array(repeating: Daily(dt: 0,
                                                     sunrise: 0,
                                                     sunset: 0,
                                                     moonrise: 0,
                                                     moonset: 0,
                                                     temp: temp(min: 0, max: 0), weather: [Weather(main: "", description: "", icon: "")]), count: 7)
    
    static var hourly_images: [UIImage] = Array(repeating: UIImage(), count: 24)
    static var daily_images: [UIImage] = Array(repeating: UIImage(), count: 7)
    
    static var icons: [String: UIImage] = [
        "01d": UIImage(),
        "02d": UIImage(),
        "03d": UIImage(),
        "04d": UIImage(),
        "09d": UIImage(),
        "10d": UIImage(),
        "11d": UIImage(),
        "13d": UIImage(),
        "50d": UIImage(),
        "01n": UIImage(),
        "02n": UIImage(),
        "03n": UIImage(),
        "04n": UIImage(),
        "09n": UIImage(),
        "10n": UIImage(),
        "11n": UIImage(),
        "13n": UIImage(),
        "50n": UIImage()
    ]
    static var icon_cache_status: [String: Bool] = [
        "01d": false,
        "02d": false,
        "03d": false,
        "04d": false,
        "09d": false,
        "10d": false,
        "11d": false,
        "13d": false,
        "50d": false,
        "01n": false,
        "02n": false,
        "03n": false,
        "04n": false,
        "09n": false,
        "10n": false,
        "11n": false,
        "13n": false,
        "50n": false
    ]
    
}
