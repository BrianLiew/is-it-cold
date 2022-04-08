//
//  GameViewController.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreLocation
import AddressBookUI
import Foundation

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
        
    // MARK: - UIKit
    
    // UIScrollView
    let scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    // UIView
    let background = UIView(frame: CGRect(x: 0, y: -300, width: screen_width, height: screen_height * 3))
    // UILabel
    let time_label = UILabel(frame: CGRect(x: 25, y: 0, width: screen_width - 50, height: 100))
    let city_label = UILabel(frame: CGRect(x: 25, y: 100, width: screen_width - 50, height: 100))
    let weather_description_label = UILabel(frame: CGRect(x: 25, y: 200, width: screen_width - 50, height: 100))
    let temp_label = UILabel(frame: CGRect(x: 25, y: 300, width: screen_width / 3 - 25, height: 100))
    let wind_label = UILabel(frame: CGRect(x: screen_width / 3, y: 300, width: screen_width * 2 / 3 - 25, height: 100))
    // UITableView
    let hourly_table_view = UITableView(frame: CGRect(x: 25, y: 400, width: screen_width - 50, height: 300))
    let daily_table_view = UITableView(frame: CGRect(x: 25, y: 750, width: screen_width - 50, height: 300))
    
    var city: String = ""
    var country: String = ""
    var hourly_data: [Hourly] = Array(repeating: Hourly(dt: 0, temp: 0, wind_speed: 0, wind_deg: 0, weather: [Weather(main: "", description: "", icon: "")]), count: 24)
    var daily_data: [Daily] = Array(repeating: Daily(dt: 0, sunrise: 0, sunset: 0, moonrise: 0, moonset: 0, temp: temp(min: 0, max: 0), weather: [Weather(main: "", description: "", icon: "")]), count: 7)
    var hourly_images: [UIImage] = Array(repeating: UIImage(), count: 24)
    var daily_images: [UIImage] = Array(repeating: UIImage(), count: 7)
    var timer = Timer()

    var icons: [String: UIImage] = [
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
    var icon_cache_status: [String: Bool] = [
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

    let decoder = JSONDecoder()
    let location_manager = CLLocationManager()
    
    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        fetchLocation()
    }
    
    func fetchLocation() {
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.distanceFilter = 500
        DispatchQueue.main.async {
            self.location_manager.startUpdatingLocation()
        }
    }
    
    func initUI() -> Void {
        time_label.text = "00:00:00 --"
        city_label.text = "-"
        weather_description_label.text = "-"
        temp_label.text = "00.0 °F"
        wind_label.text = "00.0mph 000°N"

        time_label.textAlignment = .center
        city_label.textAlignment = .center
        weather_description_label.textAlignment = .center
        temp_label.textAlignment = .center
        wind_label.textAlignment = .center
        
        time_label.font = header_font
        city_label.font = header_font
        weather_description_label.font = title_font
        temp_label.font = body_font
        wind_label.font = body_font
        
        scroll_view.contentSize = CGSize(width: screen_width, height: screen_height + 500)
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.showsVerticalScrollIndicator = false
        
        hourly_table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        hourly_table_view.dataSource = self
        hourly_table_view.delegate = self
        hourly_table_view.layer.cornerRadius = 10
        hourly_table_view.showsVerticalScrollIndicator = false
        
        daily_table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        daily_table_view.dataSource = self
        daily_table_view.delegate = self
        daily_table_view.layer.cornerRadius = 10
        daily_table_view.showsVerticalScrollIndicator = false

        view.addSubview(scroll_view)
        view.sendSubviewToBack(scroll_view)
        scroll_view.addSubview(background)
        scroll_view.addSubview(time_label)
        scroll_view.addSubview(city_label)
        scroll_view.addSubview(weather_description_label)
        scroll_view.addSubview(temp_label)
        scroll_view.addSubview(wind_label)
        scroll_view.addSubview(hourly_table_view)
        scroll_view.addSubview(daily_table_view)
        
        hourly_table_view.rowHeight = 60
        daily_table_view.rowHeight = 75
                
        self.view.backgroundColor = UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 1.0)
    }
    
    func update_UI(
        city_name: String,
        country_name: String,
        weather_description_string: String,
        weather_group: String,
        temperature: Double,
        wind_speed: Double,
        wind_deg: Int,
        hourly_stats: [Hourly],
        background_view: UIView
    ) -> Void {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.updateTime()})

        self.time_label.text = getCurrentTime()
        self.city_label.text = city_name + ", " + country_name
        self.weather_description_label.text = weather_description_string
        self.temp_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temperature)) + "°F"
        self.wind_label.text = String(format: "%.1f", wind_speed) + "mph " + convert_deg_to_direction(input: wind_deg)
        
        hourly_table_view.reloadData()
        daily_table_view.reloadData()
        
        do { try initAnimation(description: weather_group, background_view: background_view) }
        catch { print("yeet") }
    }
        
    func updateTime() { self.time_label.text = getCurrentTime() }
    
    func initAnimation(description: String, background_view: UIView) throws -> Void {
        if let view = self.view as! SKView? {
                        
            switch (description) {
            case "Clear":
                day_clear_sky(view: background_view)
            case "Few Clouds":
                convert_text_to_white()
                few_clouds(view: background_view)
            case "Broken Clouds":
                convert_text_to_white()
                few_clouds(view: background_view)
            case "Clouds":
                convert_text_to_white()
                few_clouds(view: background_view)
            case "Shower Rain":
                if let scene = SKScene(fileNamed: "ShowerRain") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    // Present the scene
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Rain":
                if let scene = SKScene(fileNamed: "Rain") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Thunderstorm":
                if let scene = SKScene(fileNamed: "Thunderstorm") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Snow":
                if let scene = SKScene(fileNamed: "Snow") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            case "Mist":
                if let scene = SKScene(fileNamed: "Mist") {
                    scene.scaleMode = .aspectFill
                    convert_text_to_white()
                    view.presentScene(scene)
                }
            default:
                throw AppErrors(description: "initAnimation matches no animation case", kind: .AnimationError)
            }
            
            // view.ignoresSiblingOrder = true
            // view.showsFPS = true
            // view.showsNodeCount = true
        }
    }
    
    // MARK: ViewController utility functions
    
    func update_data(data: weather_data) -> Void {
        for index in 0...23 { self.hourly_data[index] = data.hourly[index] }
        for index in 0...6 { self.daily_data[index] = data.daily[index] }
    }
    
    func cache_images(data: weather_data) -> Void {
        for index in 0...23 {
            if (icon_cache_status[data.hourly[index].weather[0].icon] == false) {
                icons[data.hourly[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.hourly[index].weather[0].icon)@2x.png")!))!
                icon_cache_status[data.hourly[index].weather[0].icon] = true
            }
            hourly_images[index] = icons[String(data.hourly[index].weather[0].icon)]!
        }
        for index in 0...6 {
            if (icon_cache_status[data.daily[index].weather[0].icon] == false) {
                icons[data.daily[index].weather[0].icon] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.daily[index].weather[0].icon)@2x.png")!))!
                icon_cache_status[data.daily[index].weather[0].icon] = true
            }
            daily_images[index] = icons[String(data.daily[index].weather[0].icon)]!
        }
    }

        
    func convert_text_to_white() -> Void {
        time_label.textColor = white
        city_label.textColor = white
        weather_description_label.textColor = white
        temp_label.textColor = white
        wind_label.textColor = white
    }
    
    // MARK: - data fetching functions

    // completion handler for make_request() for ONE CALL. Parses data.
    func parse_json(json: Data?) -> Void {
        if let json_unwrapped = json {
            DispatchQueue.main.async {
                let weather_data = try? self.decoder.decode(weather_data.self, from: json_unwrapped)
                if let weather_data_unwrapped = weather_data {
                    // print(weather_data_unwrapped)
                    // weather_data_unwrapped.set_description(description: "snow") // animation debug
                    // print(weather_data_unwrapped.current.weather[0].main.capitalized) // animation debug
                    self.update_data(data: weather_data_unwrapped)
                    self.cache_images(data: weather_data_unwrapped) // MARK: fix: long loading times
                    self.update_UI(
                        city_name: self.city,
                        country_name: self.country,
                        weather_description_string: weather_data_unwrapped.current.weather[0].description.capitalized,
                        weather_group: weather_data_unwrapped.current.weather[0].main.capitalized,
                        temperature: weather_data_unwrapped.current.temp,
                        wind_speed: weather_data_unwrapped.hourly[0].wind_speed,
                        wind_deg: weather_data_unwrapped.hourly[0].wind_deg,
                        hourly_stats: weather_data_unwrapped.hourly,
                        background_view: self.background
                    )
                }
            }
        } else { print("json unwrap error") }
    }
    
    // MARK: table view data source & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.daily_table_view) { return 7 }
        else { return 24 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if (tableView == self.hourly_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.image = hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: hourly_data[indexPath.row].temp)) + "°F"
            content.secondaryText = "\(timeFormatter(current_time: Double(hourly_data[indexPath.row].dt)))"
            content.textProperties.font = cell_font
            content.secondaryTextProperties.font = secondary_cell_font

            cell.contentConfiguration = content
        }
        else if (tableView == self.daily_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: daily_data[indexPath.row].temp.min)) +  "°F ~ " + String(format: "%.1f", convert_kelvin_to_fahrenheit(input: daily_data[indexPath.row].temp.max)) + "°F"
            content.secondaryText = "\(dateFormatter(current_time: Double(daily_data[indexPath.row].dt)))"
            content.textProperties.font = cell_font
            content.secondaryTextProperties.font = secondary_cell_font
            content.image = daily_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - CoreLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else {
                    guard let error_unwrapped = error else { fatalError("Unresolved error failed to unwrap error into error_unwrapped") }
                    let nserror = error_unwrapped as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)") }

                self.city = city
                self.country = country
            }
            
            // initiate API call
            Networking.set_location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            Networking.make_request(completion_handler: parse_json)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")    }
    
    // MARK: - SpriteKit

    override var shouldAutorotate: Bool { return false }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { if UIDevice.current.userInterfaceIdiom == .phone { return .allButUpsideDown } else { return .all } }

    override var prefersStatusBarHidden: Bool { return true }
    
}

    // MARK: - Extensions

extension CLLocation {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
}
