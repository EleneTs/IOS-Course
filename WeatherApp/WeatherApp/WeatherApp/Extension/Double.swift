//
//  Double.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 2.02.22.
//

import Foundation

extension Double {

    var direction: String {
        let directions = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"]

        let i = Int((self + 11.25)/22.5)

        return directions[i % 16]
    }

    var celsius: Int {

        return Int(self - 273.15)

    }

}
