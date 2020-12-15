//
//  LocationManager.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/4/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    // MARK: Constants
    public static let shared = LocationManager()
    let manager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: Variables
    var authorized: Bool {
        get {
            return  CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        }
    }
    
    var longitude: Double? {
        get { return currentLocation?.coordinate.longitude }
    }
    
    var latitude: Double? {
        get { return currentLocation?.coordinate.latitude }
    }
    
    // MARK: Functions
    init() {
        if authorized {
            currentLocation = manager.location
        } else {
            print("User has not authorized location.")
        }
    }
    
    func requestAuthorization() { manager.requestWhenInUseAuthorization() }
    
    func refreshLocation() {
        if authorized {
            currentLocation = manager.location
        } else {
            print("User has not authorized location")
        }
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
  var locationCallback: ((CLLocation) -> ())? = nil
  var headingCallback: ((CLLocationDirection) -> ())? = nil
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    locationCallback?(currentLocation)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    headingCallback?(newHeading.trueHeading)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("ERROR: Updating location " + error.localizedDescription)
  }
}
