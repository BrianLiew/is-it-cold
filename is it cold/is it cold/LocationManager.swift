import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 500
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchLocalWeatherData() -> Void { DispatchQueue.main.async { self.manager.startUpdatingLocation() } }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            let nserror = NSError()
            fatalError("LocationManager didUpdateLocations | \(nserror): \(nserror.localizedDescription)")
        }
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else {
                guard let error_unwrapped = error else { fatalError("Unresolved error failed to unwrap error into error_unwrapped") }
                let nserror = error_unwrapped as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)") }
                        
            AllData.city = city
            AllData.country = country
                        
            NetworkingManager.makeRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion_handler: ViewController.parseJSON)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let nserror = error as NSError
        fatalError("LocationManager didFailWithError | \(nserror): \(nserror.localizedDescription)")
    }
    
}

extension CLLocation {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
}
