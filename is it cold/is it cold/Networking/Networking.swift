//
//  Networking.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation
import CoreLocation

class Networking {
    
    private let key: String = "865e25bdadd4ab58522a489eed0685de"

    var latitude: Double
    var longitude: Double
    var url: URL
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,alerts&appid=\(key)")!
    }
        
    func make_request(completion_handler: @escaping (Data?) -> Void) {        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
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
