//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 30.01.22.
//

import Foundation

class ServiceManager {

    private let client: NetworkClient = NetworkClient()


    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastResponce>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: "1e9ad4416df53f1c70f42b44e0184798"),
        ]

        client.perform(urlPath: urlComponents.url!, completion: completion)
    }

    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherResponce>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: "1e9ad4416df53f1c70f42b44e0184798"),
        ]
        client.perform(urlPath: urlComponents.url!, completion: completion)
    }

}

enum Result<Value> {
    case success(Value)
    case failure(WeatherError)
}
