//
//  Networking.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation
import CoreLocation

class Networking {
    
    private static let key: String = "865e25bdadd4ab58522a489eed0685de"
    private static var url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,alerts&appid=\(key)")!
    
    static var latitude: Double = 00.00
    static var longitude: Double = 00.00
    
    static let session = URLSession(configuration: URLSessionConfiguration.default)
    
    static func set_location(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func make_request(completion_handler: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            let task = session.dataTask(with: self.url) { data, response, error in
                guard let http_response = response as? HTTPURLResponse,
                      (200...299).contains(http_response.statusCode) else {
                          if let error_unwrapped = error { print("http response error: \(error_unwrapped.localizedDescription)") }
                          return
                      }
                // check if data is JSON
                guard let mime = response?.mimeType, mime == "application/json" else {
                    if let error_unwrapped = error { print("MIME error: \(error_unwrapped.localizedDescription)") }
                    return
                }
                if let data_unwrapped = data { completion_handler(data_unwrapped) }
            }
            task.resume()
        }
    }
    
}
