//
//  URL and Key.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

private let key: String = "865e25bdadd4ab58522a489eed0685de"

private let city: String = "Binghamton"
private let lat: Double = 33.44
private let lon: Double = -94.04

// current weather data
let current_url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)")

// one call api
let one_url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&appid=\(key)")

// one url example url https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&exclude=minutely,alerts&appid=865e25bdadd4ab58522a489eed0685de

