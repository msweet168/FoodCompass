//
//  LocationManager.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/4/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    // MARK: Constants
    public static let shared = LocationManager()
    let manager = CLLocationManager()
   
    // MARK: Variables
    var currentLocation: CLLocation?
    var authorized: Bool {
        get {
            return manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus ==  .authorizedAlways
        }
    }
    
    var longitude: Double? {
        get { return currentLocation?.coordinate.longitude }
    }
    
    var latitude: Double? {
        get { return currentLocation?.coordinate.latitude }
    }
    
    var heading: Double? {
        get { return manager.heading?.trueHeading }
    }
    
    // MARK: Functions
    init() {
        setupLocationManager()
    }
    
    func setupLocationManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        refreshLocation()
    }
    
    func setDelegate(delegate: CLLocationManagerDelegate) {
        manager.delegate = delegate
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func refreshLocation() {
        if authorized {
            currentLocation = manager.location
        } else {
            print("User has not authorized location")
        }
    }
}
