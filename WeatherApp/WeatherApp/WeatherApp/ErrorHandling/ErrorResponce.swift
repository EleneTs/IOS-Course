//
//  ErrorResponce.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 2.02.22.
//

import Foundation

enum WeatherError: LocalizedError {
    
    case badConnection
    case badResponse
    case invalidAPIKey
    case serverUnavailable
    case noAccess

    var errorDescription: String {
        switch self {
        case .badConnection:
            return "Bad connection"
        case .badResponse:
            return "Bad response"
        case .invalidAPIKey:
            return "Invalid API key!"
        case .serverUnavailable:
            return "Server unavailable, please try again later"
        case .noAccess:
            return "App has no access to location services, please try again later"
        }

    }
}
