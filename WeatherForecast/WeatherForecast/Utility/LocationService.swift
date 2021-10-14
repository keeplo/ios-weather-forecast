//
//  LocationService.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/13.
//

import CoreLocation

class LocationService: NSObject {
    typealias ReceivedLocationAction = (CLLocation) -> Void
    
    private var receivedLocationAction: ReceivedLocationAction?
    
    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        
        locationManager.delegate = self
    }

    func requestLocation(receiveLocationAction: ReceivedLocationAction?) {
        self.receivedLocationAction = receiveLocationAction
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("restricted, denied")
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let lastLocation = locations.last {
            receivedLocationAction?(lastLocation)
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        locationManager.requestLocation()
    }
}
