//
//  ForecastResponce.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 30.01.22.
//


// api: 1e9ad4416df53f1c70f42b44e0184798

import Foundation

struct ForecastResponce: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
}
struct List: Codable {
    let dt: Int64
    let main: MainF
    let weather: [WeatherF]
    let clouds: CloudsF
    let wind: WindF
    let visibility: Double
    let pop: Double
    let sys: SysF
    let dt_txt: String
    let city: City?

}

struct MainF: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let sea_level: Double
    let grnd_level: Double
    let pressure: Double
    let humidity: Double
    let temp_kf: Double
}

struct WeatherF: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WindF: Codable {
    let speed: Double
    let deg: Double
    let gust: Double
}

struct SysF: Codable {
    let pod: String
}

struct CloudsF: Codable {
    let all: Int64
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: CoordinateF
    let country: String
    let population: Int64
    let timezone: Int
    let sunrise: Double
    let sunset: Double
}

struct CoordinateF: Codable {
    let lon: Double
    let lat: Double
}
