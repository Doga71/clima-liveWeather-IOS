//
//  WeatherData.swift
//  Clima
//
//  Created by Aditya kumar on 16/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable{
    let temp: Double
}
struct Weather: Codable {
    let id: Int
}
