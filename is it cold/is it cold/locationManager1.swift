//
//  locationManager.swift
//  is it cold
//
//  Created by Brian Liew on 1/18/22.
//

import Foundation
import UIKit
import CoreLocation
import AddressBookUI

class locationManager1: NSObject, CLLocationManagerDelegate {
    
    let cl_manager = CLLocationManager()
    
    var city: String
    var country: String
    var location: CLLocation
    
    override init() {
        self.city = "test"
        self.country = ""
        self.location = CLLocation()
    }
    
    func init_manager() {
        cl_manager.delegate = self
        cl_manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                self.city = city
                self.country = country
             }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription.description)
    }
    
}
