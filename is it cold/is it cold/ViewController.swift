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

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

let white = UIColor(red: 1, green: 1, blue: 0.92, alpha: 1)

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
        
    // MARK: - UIView element declarations
    
    // MARK: UIScrollView
    let scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    // let forecast_scrollview = UIScrollView(frame: CGRect(x: 0, y: screen_height / 2, width: screen_width, height: 350))
    // MARK: UIStackView
    // let forecast_stackview = UIStackView(frame: CGRect(x: 0, y: screen_height, width: screen_width, height: 350))
    // MARK: UILabel
    let background = UIView(frame: CGRect(x: 0, y: -300, width: screen_width, height: screen_height * 3))
    let city_label = UILabel(frame: CGRect(x: 25, y: 0, width: screen_width - 50, height: 100))
    let weather_description_label = UILabel(frame: CGRect(x: 25, y: 100, width: screen_width - 50, height: 100))
    let temp_label = UILabel(frame: CGRect(x: 25, y: 200, width: screen_width / 3 - 25, height: 100))
    let wind_label = UILabel(frame: CGRect(x: screen_width / 3, y: 200, width: screen_width * 2 / 3 - 25, height: 100))
    // MARK: UITableView
    let hourly_table_view = UITableView(frame: CGRect(x: 25, y: 400, width: screen_width - 50, height: 300))
    let daily_table_view = UITableView(frame: CGRect(x: 25, y: 750, width: screen_width - 50, height: 300))
    
    // MARK: - data structure declarations
    // MARK: Variables
    var city: String = ""
    var country: String = ""
    // MARK: Array
    var hourly_data: [Hourly] = Array(repeating: Hourly(dt: 0, temp: 0, wind_speed: 0, wind_deg: 0, weather: [Weather(main: "", description: "", icon: "")]), count: 24)
    var daily_data: [Daily] = Array(repeating: Daily(dt: 0, temp: temp(min: 0, max: 0), weather: [Weather(main: "", description: "", icon: "")]), count: 7)
    var hourly_images: [UIImage] = Array(repeating: UIImage(), count: 24)
    var daily_images: [UIImage] = Array(repeating: UIImage(), count: 7)
    // MARK: Dictionary
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
    // MARK: Decodable
    let decoder = JSONDecoder()
    // MARK: CLLocation
    let location_manager = CLLocationManager()
    
    // MARK: - ViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        init_location_manager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_UI()
        // init_location_manager()
        // let network_instance = Networking(latitude: 40.76, longitude: -73.78)
        // network_instance.make_request(completion_handler: request_completion_handler)
    }
    
    func init_location_manager() {
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestLocation()
    }
    
    // initiation of data-displaying elements. Called in viewDidLoad.
    func init_UI() -> Void {
        city_label.text = "-"
        weather_description_label.text = "-"
        temp_label.text = "00.0 °F"
        wind_label.text = "00.0mph 000°N"

        city_label.textAlignment = .center
        weather_description_label.textAlignment = .center
        temp_label.textAlignment = .center
        wind_label.textAlignment = .center
        
        city_label.font = regular_font
        weather_description_label.font = title_font
        temp_label.font = regular_font
        wind_label.font = regular_font
        
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
    
    // updates data-displaying elements and background animations. Called in request_completion_handler. ONE CALL only.
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
        // update current weather data
        self.city_label.text = city_name + ", " + country_name
        self.weather_description_label.text = weather_description_string
        self.temp_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temperature)) + "°F"
        self.wind_label.text = String(format: "%.1f", wind_speed) + "mph " + convert_deg_to_direction(input: wind_deg)
                        
        hourly_table_view.reloadData()
        daily_table_view.reloadData()

        init_animation(description: weather_group, background_view: background_view)
    }
    
    func init_animation(description: String, background_view: UIView) -> Void {
        if let view = self.view as! SKView? {
            
            switch (description) {
            case "Clear Sky":
                clear_sky(view: background_view)
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
            default: print("default")
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
    
    func time_formatter(current_time: Double) -> String {
        let time = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "hh:mm a"
        let time_string = format.string(from: time)
        
        return time_string
    }
    
    func date_formatter(current_time: Double) -> String {
        let date = Date(timeIntervalSince1970: current_time)

        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "E MMM DD"
        let date_string = format.string(from: date)
        
        return date_string
    }
        
    func convert_text_to_white() -> Void {
        city_label.textColor = white
        weather_description_label.textColor = white
        temp_label.textColor = white
        wind_label.textColor = white
    }
    
    // MARK: - data fetching functions

    // completion handler for make_request() for ONE CALL. Parses data.
    func request_completion_handler(json: Data?) -> Void {
        if let json_unwrapped = json {
            DispatchQueue.main.async {
                let weather_data = try? self.decoder.decode(weather_data.self, from: json_unwrapped)
                if let weather_data_unwrapped = weather_data {
                    // weather_data_unwrapped.set_description(description: "snow") // animation debugging purposes only
                    self.update_data(data: weather_data_unwrapped)
                    self.cache_images(data: weather_data_unwrapped) // fix: long loading times
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
            
            content.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: hourly_data[indexPath.row].temp)) + "°F"
            content.secondaryText = "\(time_formatter(current_time: Double(hourly_data[indexPath.row].dt)))"
            content.textProperties.font = cell_font!
            content.secondaryTextProperties.font = secondary_cell_font!
            content.image = hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        else if (tableView == self.daily_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: daily_data[indexPath.row].temp.min)) +  "°F ~ " + String(format: "%.1f", convert_kelvin_to_fahrenheit(input: daily_data[indexPath.row].temp.max)) + "°F"
            content.secondaryText = "\(date_formatter(current_time: Double(daily_data[indexPath.row].dt)))"
            content.textProperties.font = cell_font!
            content.secondaryTextProperties.font = secondary_cell_font!
            content.image = daily_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // update location label
            location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                self.city = city
                self.country = country
            }
            // initiate API call
            Networking.set_location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            Networking.make_request(completion_handler: request_completion_handler)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location")
    }
    
    // MARK: - SpriteKit default functions

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension CLLocation {
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
}
