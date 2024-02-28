//
//  CurrentWeatherResponce.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 30.01.22.
//

import Foundation

struct CurrentWeatherResponce: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

struct Clouds: Codable {
    let all: Int64
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int64
    let sunset: Int64

}
