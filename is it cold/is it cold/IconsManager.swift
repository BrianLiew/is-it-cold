import Foundation
import UIKit

class IconsManager {
    
    static func cacheIcons(data: weather_data) -> Void {
        for index in 0...23 {
            if (AllData.icon_cache_status[data.hourly[index].weather[0].icon] == false) {
                AllData.icons[data.hourly[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.hourly[index].weather[0].icon)@2x.png")!))!
                AllData.icon_cache_status[data.hourly[index].weather[0].icon] = true
            }
            AllData.hourly_images[index] = AllData.icons[String(data.hourly[index].weather[0].icon)]!
        }
        for index in 0...6 {
            if (AllData.icon_cache_status[data.daily[index].weather[0].icon] == false) {
                AllData.icons[data.daily[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.daily[index].weather[0].icon)@2x.png")!))!
                AllData.icon_cache_status[data.daily[index].weather[0].icon] = true
            }
            AllData.daily_images[index] = AllData.icons[String(data.daily[index].weather[0].icon)]!
        }
    }
    
}
