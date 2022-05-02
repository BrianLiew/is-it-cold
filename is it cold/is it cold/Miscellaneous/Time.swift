import Foundation

class Time {
 
    static func timeFormatter(current_time: Double) -> String {
        let time = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "hh:mm a"
        let time_string = format.string(from: time)
        
        return time_string
    }

    static func dateFormatter(current_time: Double) -> String {
        let date = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "E MMM dd"
        let date_string = format.string(from: date)
        
        return date_string
    }

    static func getCurrentTime() -> String {
        let date = Date()
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "hh:mm:ss a"
        let time_string = format.string(from: date)
     
        return time_string
    }
    
}
