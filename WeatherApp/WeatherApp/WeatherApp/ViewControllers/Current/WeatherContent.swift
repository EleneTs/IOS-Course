//
//  WeatherContent.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 4.02.22.
//

import Foundation
import CoreLocation

struct WeatherContent {
    var weatherIcon: String
    var locationLabel: String
    var weatherDescriptionLabel: String
    var weatherDetails: [String]

    init(responce: CurrentWeatherResponce){
        weatherIcon = responce.weather.first?.icon ?? ""
        locationLabel = responce.name + ", " + responce.sys.country
        weatherDescriptionLabel = "\(responce.main.temp.celsius)°C"  + " | " + (responce.weather.first?.main  ?? "")

        weatherDetails = ["\(responce.clouds.all) %","\(Int(responce.main.humidity)) mm","\(responce.main.pressure) \("hPa")","\(responce.wind.speed) \("km/h")","\(responce.wind.deg.direction)"]

    }
}
