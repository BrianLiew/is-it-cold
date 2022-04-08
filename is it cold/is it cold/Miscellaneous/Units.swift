//
//  Units.swift
//  is it cold
//
//  Created by Brian Liew on 1/1/22.
//

import Foundation

func convert_kelvin_to_fahrenheit(input: Double) -> Double { return ((input - 273.15) * 1.8 + 32) }

func convert_deg_to_direction(input: Int) -> String {
    switch input {
    case 0...89:
        return (String(format: "%d", input) + "°N")
    case 90...179:
        return (String(format: "%d", input - 90) + "°E")
    case 180...269:
        return (String(format: "%d", input - 180) + "°S")
    case 270...359:
        return (String(format: "%d", input - 270) + "°W")
    default:
        return String(format: "%d", input)
    }
}
