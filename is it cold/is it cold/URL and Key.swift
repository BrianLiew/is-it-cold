//
//  URL and Key.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

private let key: String = "865e25bdadd4ab58522a489eed0685de"
private let city: String = "Binghamton"

let forecast_url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(key)")
