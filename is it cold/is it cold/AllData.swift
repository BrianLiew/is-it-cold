import Foundation
import UIKit

struct Container {
    
    static let instance = Container()
    
    // MARK: - Containers
    
    var city: String = ""
    
    var country: String = ""
    
    var hourly_data: [Hourly] = Array(repeating: Hourly(dt: 0,
                                                        temp: 0,
                                                        wind_speed: 0,
                                                        wind_deg: 0,
                                                        weather: [Weather(main: "", description: "", icon: "")]), count: 24)
    
    var daily_data: [Daily] = Array(repeating: Daily(dt: 0,
                                                     sunrise: 0,
                                                     sunset: 0,
                                                     moonrise: 0,
                                                     moonset: 0,
                                                     temp: temp(min: 0, max: 0), weather: [Weather(main: "", description: "", icon: "")]), count: 7)
    
    var hourly_icons: [UIImage] = Array(repeating: UIImage(), count: 24)
    
    var daily_icons: [UIImage] = Array(repeating: UIImage(), count: 7)
    
}
