//
//  SettingsManager.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/13/21.
//  Copyright © 2021 Mitchell Sweet. All rights reserved.
//

import Foundation

class SettingsManager {
    
    let defaultRadius = 2
    
    private struct UserDefaultsKeys {
        static let UNITS = "units"
        static let RADIUS = "radius"
    }
    
    public static var units: UnitType {
        get { return UnitType(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKeys.UNITS) ?? UnitType.imperial.rawValue) ?? .imperial }
        set { UserDefaults.standard.setValue(newValue.rawValue, forKey: UserDefaultsKeys.UNITS) }
    }
    
    /// Returns saved radius in miles
    public static var radius: Int {
        get { return UserDefaults.standard.integer(forKey: UserDefaultsKeys.RADIUS) }
        set { UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.RADIUS) }
    }
    
    /// Returns saved radius in current units that are set in defaults.
    public static var convertedRadius: Int {
        return units == .imperial ? radius : Int(round(Double(radius)*1.609344))
    }
    
    public static var radiusInMeters: Double {
        return Double(self.radius)/0.00062137
    }
    
    public static func metersToUnits(meters: Double) -> Double {
        return units == .imperial ? meters *  0.00062137 : meters/1000
    }
    
    init() {
        // Register User Defaults on first launch
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.UNITS: UnitType.imperial.rawValue,
            UserDefaultsKeys.RADIUS: defaultRadius,
        ])
    }
}

