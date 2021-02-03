//
//  WeatherManager.swift
//  Clima
//
//  Created by Aditya kumar on 16/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ WeatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=8d2c28d4f39cd0d4015bccce9e2e3534&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
       // print(urlString)
        performRequest(ulrString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(ulrString: urlString)
    }
    
    func performRequest(ulrString: String){ //performing networking.
        //1.create a url
        if let url = URL(string: ulrString) {
            //2.create a url session
            let session = URLSession(configuration: .default)
            //3.give a session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                   // let dataString = String(data: safeData, encoding: .utf8)
                   // print(dataString!)
                    if let weather = self.parseJSON(weatherData: safeData) {
                    //self. is used inside closures
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start the task     
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //print(decodedData.name)
            //print(decodedData.main.temp)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            //print(weather.conditionName)
            //print(weather.temperatureString)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

