//
//  Delegate.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 3.02.22.
//

import Foundation

protocol WeatherDataUpdatedDelegate {
    func weatherInfoViewModelUpdated()
    func errorOccurred(errorDescription: String, retryAction: (() -> ())?)
    var errorView: ErrorView? { get set }
}
