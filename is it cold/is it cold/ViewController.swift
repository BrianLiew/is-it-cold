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
    
    static let scroll_view = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    static let animation_SKView = SKView(frame: CGRect(x: 0, y: -300, width: screen_width, height: screen_height * 3))
    static let animation_UKView = UIView(frame: CGRect(x: 0, y: -300, width: screen_width, height: screen_height * 3))
    static let hourly_table_view = UITableView(frame: CGRect(x: 25, y: 400, width: screen_width - 50, height: 300))
    static let daily_table_view = UITableView(frame: CGRect(x: 25, y: 750, width: screen_width - 50, height: 300))
    
    static let city_label = UILabel(frame: CGRect(x: 25, y: 100, width: screen_width - 50, height: 100))
    static let temp_label = UILabel(frame: CGRect(x: 25, y: 300, width: screen_width / 3 - 25, height: 100))
    static let time_label = UILabel(frame: CGRect(x: 25, y: 0, width: screen_width - 50, height: 100))
    static let weather_description_label = UILabel(frame: CGRect(x: 25, y: 200, width: screen_width - 50, height: 100))
    static let wind_label = UILabel(frame: CGRect(x: screen_width / 3, y: 300, width: screen_width * 2 / 3 - 25, height: 100))

    static var timer = Timer()
    static let decoder = JSONDecoder()
    let location_manager = LocationManager()
    
    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        self.location_manager.fetchLocalWeatherData()
    }
    
    func initUI() -> Void {
        ViewController.time_label.text = "Updated: 00:00:00 --"
        ViewController.city_label.text = "---"
        ViewController.weather_description_label.text = "---"
        ViewController.temp_label.text = "00.0 °F"
        ViewController.wind_label.text = "00.0 mph 000°N"

        ViewController.time_label.textAlignment = .center
        ViewController.city_label.textAlignment = .center
        ViewController.weather_description_label.textAlignment = .center
        ViewController.temp_label.textAlignment = .center
        ViewController.wind_label.textAlignment = .center
        
        ViewController.time_label.font = Fonts.header_font
        ViewController.city_label.font = Fonts.header_font
        ViewController.weather_description_label.font = Fonts.title_font
        ViewController.temp_label.font = Fonts.body_font
        ViewController.wind_label.font = Fonts.body_font
        
        ViewController.scroll_view.contentSize = CGSize(width: screen_width, height: screen_height + 500)
        ViewController.scroll_view.translatesAutoresizingMaskIntoConstraints = false
        ViewController.scroll_view.showsVerticalScrollIndicator = false
        
        ViewController.hourly_table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ViewController.hourly_table_view.dataSource = self
        ViewController.hourly_table_view.delegate = self
        ViewController.hourly_table_view.layer.cornerRadius = 10
        ViewController.hourly_table_view.showsVerticalScrollIndicator = false
        
        ViewController.daily_table_view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ViewController.daily_table_view.dataSource = self
        ViewController.daily_table_view.delegate = self
        ViewController.daily_table_view.layer.cornerRadius = 10
        ViewController.daily_table_view.showsVerticalScrollIndicator = false

        view.addSubview(ViewController.scroll_view)
        view.sendSubviewToBack(ViewController.scroll_view)
        ViewController.scroll_view.addSubview(ViewController.animation_SKView)
        ViewController.scroll_view.addSubview(ViewController.animation_UKView)
        ViewController.scroll_view.addSubview(ViewController.time_label)
        ViewController.scroll_view.addSubview(ViewController.city_label)
        ViewController.scroll_view.addSubview(ViewController.weather_description_label)
        ViewController.scroll_view.addSubview(ViewController.temp_label)
        ViewController.scroll_view.addSubview(ViewController.wind_label)
        ViewController.scroll_view.addSubview(ViewController.hourly_table_view)
        ViewController.scroll_view.addSubview(ViewController.daily_table_view)
        
        ViewController.hourly_table_view.rowHeight = 60
        ViewController.daily_table_view.rowHeight = 75
                
        self.view.backgroundColor = UIColor(red: 0, green: 0.25, blue: 0.5, alpha: 1.0)
    }
    
    static func updateUI(
        city_name: String,
        country_name: String,
        weather_description_string: String,
        weather_group: String,
        temperature: Double,
        wind_speed: Double,
        wind_deg: Int,
        hourly_stats: [Hourly]
    ) -> Void {
        // continuous time updates
        // timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.updateTime()})

        self.time_label.text = "Updated: " + Time.getCurrentTime()
        self.city_label.text = city_name + ", " + country_name
        self.weather_description_label.text = weather_description_string
        self.temp_label.text = String(format: "%.1f", Units.convertKelvinToFahrenheit(input: temperature)) + "°F"
        self.wind_label.text = String(format: "%.1f", wind_speed) + "mph " + Units.convertDegreesToDirection(input: wind_deg)
        
        hourly_table_view.reloadData()
        daily_table_view.reloadData()
        
        do { try AnimationManager.initAnimation(description: weather_group) }
        catch { fatalError("ViewController.swift updateUI(): cannot initiate animation") }
    }
        
    func updateTime() { ViewController.time_label.text = "Updated: " + Time.getCurrentTime() }
    
    // MARK: ViewController utility functions
    
    static func updateData(data: weather_data) -> Void {
        for index in 0...23 { AllData.hourly_data[index] = data.hourly[index] }
        for index in 0...6 { AllData.daily_data[index] = data.daily[index] }
    }
        
    static func enableWhiteText() -> Void {
        ViewController.time_label.textColor = white
        ViewController.city_label.textColor = white
        ViewController.weather_description_label.textColor = white
        ViewController.temp_label.textColor = white
        ViewController.wind_label.textColor = white
    }
    
    // MARK: - data fetching functions

    // completion handler for make_request() for ONE CALL. Parses data.
    static func parseJSON(json: Data?) -> Void {
        if let json_unwrapped = json {
            DispatchQueue.main.async {
                let weather_data = try? ViewController.decoder.decode(weather_data.self, from: json_unwrapped)
                if var weather_data_unwrapped = weather_data {
                    // print(weather_data_unwrapped)
                    weather_data_unwrapped.set_description(description: "snow") // animation debug
                    // print(weather_data_unwrapped.current.weather[0].main.capitalized) // animation debug
                    self.updateData(data: weather_data_unwrapped)
                    IconsManager.cacheIcons(data: weather_data_unwrapped) // MARK: fix: long loading times
                    self.updateUI(
                        city_name: AllData.city,
                        country_name: AllData.country,
                        weather_description_string: weather_data_unwrapped.current.weather[0].description.capitalized,
                        weather_group: weather_data_unwrapped.current.weather[0].main.capitalized,
                        temperature: weather_data_unwrapped.current.temp,
                        wind_speed: weather_data_unwrapped.hourly[0].wind_speed,
                        wind_deg: weather_data_unwrapped.hourly[0].wind_deg,
                        hourly_stats: weather_data_unwrapped.hourly
                    )
                }
            }
        } else { fatalError("ViewController.swift parseJSON(:Data?): Failed to unwrap optional json") }
    }
    
    // MARK: table view data source & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ViewController.daily_table_view) { return 7 }
        else { return 24 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        if (tableView == ViewController.hourly_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.image = AllData.hourly_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.text = String(format: "%.1f", Units.convertKelvinToFahrenheit(input: AllData.hourly_data[indexPath.row].temp)) + "°F"
            content.secondaryText = "\(Time.timeFormatter(current_time: Double(AllData.hourly_data[indexPath.row].dt)))"

            content.textProperties.font = Fonts.cell_font
            content.secondaryTextProperties.font = Fonts.secondary_cell_font

            cell.contentConfiguration = content
        }
        else if (tableView == ViewController.daily_table_view) {
            var content = cell.defaultContentConfiguration()
            
            content.text = String(format: "%.1f", Units.convertKelvinToFahrenheit(input: AllData.daily_data[indexPath.row].temp.min)) +  "°F ~ " + String(format: "%.1f", Units.convertKelvinToFahrenheit(input: AllData.daily_data[indexPath.row].temp.max)) + "°F"
            content.secondaryText = "\(Time.dateFormatter(current_time: Double(AllData.daily_data[indexPath.row].dt)))"
            content.textProperties.font = Fonts.cell_font
            content.secondaryTextProperties.font = Fonts.secondary_cell_font
            content.image = AllData.daily_images[indexPath.row]
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    // MARK: - SpriteKit

    override var shouldAutorotate: Bool { return false }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }

    override var prefersStatusBarHidden: Bool { return true }
    
}
