//
//  GameViewController.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import UIKit
import SpriteKit
import GameplayKit

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

let title_font = UIFont(name: "Chalkduster", size: 36)
let big_font = UIFont(name: "Chalkduster", size: 24)
let small_font = UIFont(name: "Chalkduster", size: 16)

let off_white = UIColor(red: 1, green: 1, blue: 0.92, alpha: 1)

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let instance = AllData.instance
    
    // MARK: - UI element declarations
    
    // MARK: current weather UI elements
    let scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    let forecast_scrollview = UIScrollView(frame: CGRect(x: 0, y: screen_height / 2, width: screen_width, height: 350))
    let forecast_stackview = UIStackView(frame: CGRect(x: 0, y: screen_height, width: screen_width, height: 350))

    let background = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    // let temperature_background = UIView(frame: CGRect(x: 0, y: screen_height / 2, width: screen_width, height: 175))
    // let wind_background = UIView(frame: CGRect(x: 0, y: screen_height / 2 + 175, width: screen_width, height: 175))
    let city_label = UILabel(frame: CGRect(x: 0, y: screen_height / 4 - 150, width: screen_width, height: 100))
    
    let weather_description_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 4 - 25, width: 300, height: 50))
    let temp_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 4 + 50, width: 300, height: 50)) /*
    let temp_title = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2, width: 300, height: 50))
    let temp_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 50, width: 200, height: 100))
    let temp_max_label = UILabel(frame: CGRect(x: screen_width / 2 + 50, y: screen_height / 2 + 50, width: 100, height: 50))
    let temp_min_label = UILabel(frame: CGRect(x: screen_width / 2 + 50, y: screen_height / 2 + 100, width: 100, height: 50))
    let wind_title = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 175, width: 300, height: 50))
    let wind_deg_label = UILabel(frame: CGRect(x: screen_width / 2 - 150, y: screen_height / 2 + 225, width: 150, height: 100))
    let wind_speed_label = UILabel(frame: CGRect(x: screen_width / 2, y: screen_height / 2 + 225, width: 150, height: 100)) */
    
    // MARK: one call UI elements
    let hourly_table_view = UITableView(frame: CGRect(x: 50, y: screen_height / 2, width: screen_width - 100, height: 300))
    let daily_table_view = UITableView(frame: CGRect(x: 50, y: screen_height / 2 + 350, width: screen_width - 100, height: 300))
    
    // MARK: data variable declarations
    var hourly_data: [Hourly] = Array(repeating: Hourly(dt: 0, temp: 0, wind_speed: 0, weather: []), count: 24)
    var daily_data: [Daily] = Array(repeating: Daily(dt: 0, temp: nil, weather: []), count: 7)
    var hourly_images: [UIImage] = Array(repeating: UIImage(), count: 24)
    var daily_images: [UIImage] = Array(repeating: UIImage(), count: 7)
        
    // MARK: - JSONDecoder declaration
    
    let decoder = JSONDecoder()
    
    // MARK: - ViewController functions
    
    let location_manager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(location_manager.return_last_known_location())
                
        init_UI()
        
        let network_instance = Networking()
        network_instance.make_request(completion_handler: request_completion_handler)
    }
    
    // initiation of data-displaying elements. Called in viewDidLoad.
    func init_UI() -> Void {
        temp_label.layer.cornerRadius = 0.5
        temp_label.layer.masksToBounds = true
        
        city_label.text = "-"
        weather_description_label.text = "-"
        temp_label.text = "0.00 °F"

        city_label.textAlignment = .center
        weather_description_label.textAlignment = .center
        temp_label.textAlignment = .center
        
        city_label.font = big_font
        weather_description_label.font = title_font
        temp_label.font = big_font
        
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
        
        scroll_view.contentSize = CGSize(width: screen_width, height: screen_height + 500)
        
        view.sendSubviewToBack(scroll_view)
        scroll_view.addSubview(background)
        scroll_view.addSubview(city_label)
        scroll_view.addSubview(weather_description_label)
        scroll_view.addSubview(temp_label)
        
        scroll_view.addSubview(hourly_table_view)
        scroll_view.addSubview(daily_table_view)
        
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        forecast_scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.backgroundColor = UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 1.0)
    }
    
    // updates data-displaying elements and background animations. Called in request_completion_handler. ONE CALL only.
    func update_UI(
        city_name: String,
        country_name: String,
        temperature: Double,
        weather_description_string: String,
        hourly_stats: [Hourly],
        background_view: UIView
    ) -> Void {
        // update current weather data
        self.city_label.text = city_name + ", " + country_name
        self.temp_label.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: temperature)) + "°F"
        self.weather_description_label.text = weather_description_string
                        
        hourly_table_view.reloadData()
        daily_table_view.reloadData()

        init_animation(description: weather_description_string, background_view: background_view)
    }
    
    func init_animation(description: String, background_view: UIView) -> Void {
        if let view = self.view as! SKView? {
            
            switch (description) {
            case "Clear Sky":
                clear_sky(view: background_view)
            case "Few Clouds":
                few_clouds(view: background_view)
            case "Broken Clouds":
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
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    // MARK: ViewController utility functions
    
    func update_data(data: weather_data) -> Void {
        for index in 0...23 { self.hourly_data[index] = data.hourly[index] }
        for index in 0...6 { self.daily_data[index] = data.daily[index] }
    }
    
    func cache_images(data: weather_data) -> Void {
        for index in 0...23 { hourly_images[index] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.return_hourly_images(index: index))@2x.png")!))! }
        for index in 0...6 { daily_images[index] = UIImage(data: try! Data(contentsOf: URL(string: "http://openweathermap.org/img/wn/\(data.return_daily_images(index: index))@2x.png")!))! }
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
        format.dateFormat = "MMM DD  E"
        let date_string = format.string(from: date)
        
        return date_string
    }
        
    func convert_text_to_white() -> Void {
        // current weather UI elements
        city_label.textColor = off_white
        weather_description_label.textColor = off_white
        temp_label.textColor = off_white
        /*
        temp_title.textColor = off_white
        temp_max_label.textColor = off_white
        temp_min_label.textColor = off_white
        wind_title.textColor = off_white
        wind_deg_label.textColor = off_white
        wind_speed_label.textColor = off_white
        */
    }
    
    // MARK: - data fetching functions

    // completion handler for make_request() for ONE CALL. Parses data.
    func request_completion_handler(json: Data?) -> Void {
        if let json_unwrapped = json {
            DispatchQueue.main.async {
                let weather_data = try? self.decoder.decode(weather_data.self, from: json_unwrapped)
                if var weather_data_unwrapped = weather_data {
                    weather_data_unwrapped.set_description(description: "snow") // animation debugging purposes only
                    self.update_data(data: weather_data_unwrapped)
                    self.cache_images(data: weather_data_unwrapped) // fix: long loading times
                    self.update_UI(
                        city_name: "Chicago",
                        country_name: "USA",
                        temperature: weather_data_unwrapped.current.temp,
                        weather_description_string: weather_data_unwrapped.return_description().capitalized,
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
            
            content.text = String(format: "%.1f", convert_kelvin_to_fahrenheit(input: hourly_data[indexPath.row].temp)) + "°F   " + "\(time_formatter(current_time: Double(hourly_data[indexPath.row].dt)))"
            content.textProperties.font = small_font!
            content.image = hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        else if (tableView == self.daily_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = "\(date_formatter(current_time: Double(daily_data[indexPath.row].dt)))"
            content.textProperties.font = small_font!

            content.image = hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        
        return cell
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
