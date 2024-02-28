//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 3.02.22.
//


import Foundation
import UIKit
import CoreLocation


protocol LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocationCoordinate2D)
    func didChangeStatus(_ status: CLAuthorizationStatus)
}


class LocationManager : NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    var delegates: [LocationManagerDelegate] = []

    private var status: CLAuthorizationStatus?

    var hasLocationPermission: Bool {
        return status != CLAuthorizationStatus.denied
    }

    var lastLocation: CLLocationCoordinate2D?

    override init() {
        super.init()

        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

//        status = CLLocationManager.authorizationStatus()

    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setDelegate(_ delegate: LocationManagerDelegate) {
        delegates.append(delegate)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        delegates.forEach({ (delegate) in
            delegate.didUpdateLocation(location)
        })

        lastLocation = location

    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        self.status = status

        delegates.forEach({ (delegate) in
            delegate.didChangeStatus(status)
        })
    }
}

extension LocationManager {


    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let placemark = placemarks?[0] else {
                completion(nil)
                return
            }

            completion(placemark)
        }
    }
}
