//
//  Networking.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation
import CoreLocation

class Networking: CLLocationManager, CLLocationManagerDelegate {
    
    let location_manager = CLLocationManager()
    
    func make_request(completion_handler: @escaping (Data?) -> Void) {
        location_manager.delegate = self
        location_manager.requestLocation()
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        DispatchQueue.global().async {
            let task = session.dataTask(with: one_url!) { data, response, error in
                
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            print(location)
            instance.set_latitude(value: location.coordinate.latitude)
            instance.set_longitude(value: location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
}
