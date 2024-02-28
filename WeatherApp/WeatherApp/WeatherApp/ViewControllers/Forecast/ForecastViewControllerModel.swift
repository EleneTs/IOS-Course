//
//  ForecastViewControllerModel.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 1.02.22.
//

import Foundation
import CoreLocation

class ForecastViewControllerModel {

    let serviceManager = ServiceManager()
    let locationManager = LocationManager()


    var delegate: WeatherDataUpdatedDelegate?


    var weatherItems: [[ForecastTableViewCellContent]] = [] {
        didSet {
            delegate?.weatherInfoViewModelUpdated()
        }
    }

    var headerItems: [ForecastHeaderViewModel] = []

    var retryAction: (() -> ())?


    init() {

        locationManager.setDelegate(self)

        retryAction = {
            guard let location = self.locationManager.lastLocation else {
                self.locationManager.requestLocation()
                return
            }

            self.fetchWeatherForecast(latitude: location.latitude, longitude: location.longitude)
        }
    }

    func fetchWeatherForecast(latitude: Double?, longitude: Double?) {

        guard let latitude = latitude, let longitude = longitude else {
            return
        }

        serviceManager.fetchWeatherForecast(latitude: latitude, longitude: longitude) { [weak self] (result) in

            switch result {
            case .success(let response):

                guard let self = self else { return }

                var weatherItems: [[ForecastTableViewCellContent]] = []
                var headerItems: [ForecastHeaderViewModel] = []

                response.list.sorted(by: { $0.dt  < $1.dt }).forEach({ (item) in

                    let headerItem = ForecastHeaderViewModel(item: item)

                    if !headerItems.contains(headerItem) {
                        headerItems.append(headerItem)
                        weatherItems.append([])
                    }

                    weatherItems[headerItems.count - 1].append(ForecastTableViewCellViewModel(from: item))

                })

                self.headerItems = headerItems
                self.weatherItems = weatherItems

                self.delegate?.weatherInfoViewModelUpdated()

            case .failure(let error):
                self?.delegate?.errorOccurred(errorDescription: error.errorDescription, retryAction: self?.retryAction)
            }
        }
    }
}

extension ForecastViewControllerModel: LocationManagerDelegate {
    func didChangeStatus(_ status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.requestLocation()

            default:
                delegate?.errorOccurred(errorDescription: WeatherError.noAccess.errorDescription, retryAction: {

                })
            }
    }

    func didUpdateLocation(_ location: CLLocationCoordinate2D) {
        fetchWeatherForecast(latitude: location.latitude, longitude: location.longitude)
    }

}

