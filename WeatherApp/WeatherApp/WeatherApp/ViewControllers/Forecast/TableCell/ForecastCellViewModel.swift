//
//  ForecastCellViewModel.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import UIKit

protocol ForecastTableViewCellContent {

    var weatherIcon: String? { get }
    var timeLabelText: String { get }
    var weatherDescriptionText: String { get }
    var temperatureValue: String { get }

}

protocol ForecastTableViewCellConfigurable {

    func configure(with content: ForecastTableViewCellContent)

}

struct ForecastTableViewCellViewModel: ForecastTableViewCellContent {

    let weatherIcon: String?
    let timeLabelText: String
    let weatherDescriptionText: String
    let temperatureValue: String

    init(from response: List) {

        weatherIcon = response.weather.first?.icon
        timeLabelText = Date.from(string: response.dt_txt)?.hour ?? ""
        weatherDescriptionText = response.weather.first?.description ?? ""
        temperatureValue = "\(response.main.temp.celsius)°C"
    }

}
