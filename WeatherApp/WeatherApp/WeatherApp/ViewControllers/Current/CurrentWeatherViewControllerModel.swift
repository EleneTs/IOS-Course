//
//  CurrentWeatherViewControllerModel.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 3.02.22.
//

import Foundation
import CoreLocation

class CurrentWeatherViewControllerModel {

    let serviceManager = ServiceManager()
    let locationManager = LocationManager()

    var delegate: WeatherDataUpdatedDelegate?


    var weatherContent: WeatherContent? {
        didSet {
            delegate?.weatherInfoViewModelUpdated()
        }
    }

    var locationLabel: String? 

    var retryAction: (() -> ())?

    init() {

        locationManager.setDelegate(self)

        retryAction = {
            guard let location = self.locationManager.lastLocation else {
                self.locationManager.requestLocation()
                return
            }

            self.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        }
    }

    func fetchCurrentWeather(latitude: Double?, longitude: Double?) {

        guard let latitude = latitude, let longitude = longitude else {
            return
        }

        serviceManager.fetchCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] (result) in

            switch result {
            case .success(let response):

                guard let self = self else { return }

                self.weatherContent = WeatherContent(responce: response)
                self.delegate?.weatherInfoViewModelUpdated()

            case .failure(let error):

                self?.delegate?.errorOccurred(errorDescription: error.errorDescription, retryAction: self?.retryAction)

            }
        }
    }
}

extension CurrentWeatherViewControllerModel: LocationManagerDelegate {
    func didChangeStatus(_ status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.requestLocation()

            default:
            delegate?.errorOccurred(errorDescription: WeatherError.noAccess.errorDescription, retryAction: {})
            }
    }


    func didUpdateLocation(_ location: CLLocationCoordinate2D) {
        fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude)
    }

}

extension CurrentWeatherViewControllerModel {
    func getCity(_ location: CLLocation) {
        self.locationManager.getPlace(for: location) { placemark in
            guard let placemark = placemark else { return }

            var output = ""
            if let town = placemark.locality {
                output = output + "\(town),"
            }

            if let state = placemark.administrativeArea {
                output = output + " \(state),"
            }

            if let country = placemark.isoCountryCode {
                output = output + " \(country)"
            }
            self.locationLabel = output
        }
    }
}
