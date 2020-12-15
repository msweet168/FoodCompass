//
//  Declarations.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/6/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: Food Items
let foodItems: [FoodItem] = [
    FoodItem(category: .coffee,     image: UIImage(named: "Coffee")!,    displayName: "Coffee Shops"),
    FoodItem(category: .fastFood,   image: UIImage(named: "Fries")!,     displayName: "Fast Food"),
    FoodItem(category: .icecream,   image: UIImage(named: "Ice Cream")!, displayName: "Ice Cream"),
    FoodItem(category: .chinese,    image: UIImage(named: "Chinese")!,   displayName: "Chinese Food"),
    FoodItem(category: .pancakes,   image: UIImage(named: "Pancakes")!,  displayName: "Pancake Houses"),
    FoodItem(category: .italian,    image: UIImage(named: "Pasta")!,     displayName: "Italian Food"),
    FoodItem(category: .pizza,      image: UIImage(named: "Pizza")!,     displayName: "Pizza"),
    FoodItem(category: .salad,      image: UIImage(named: "Salad")!,     displayName: "Salad"),
    FoodItem(category: .sushi,      image: UIImage(named: "Sushi")!,     displayName: "Sushi"),
    FoodItem(category: .tacos,      image: UIImage(named: "Taco")!,      displayName: "Tacos"),
    FoodItem(category: .tea,        image: UIImage(named: "Tea")!,       displayName: "Tea Shops"),
    FoodItem(category: .sandwiches, image: UIImage(named: "Sandwich")!,  displayName: "Sandwich Shops"),
    FoodItem(category: .bars,       image: UIImage(named: "Beer")!,      displayName: "Bars"),
    FoodItem(category: .hotdog,     image: UIImage(named: "Hot Dog")!,   displayName: "Hot Dogs"),
    FoodItem(category: .grocery,    image: UIImage(named: "Groceries")!, displayName: "Grocery Stores"),
    FoodItem(category: .seafood,    image: UIImage(named: "Fish")!,      displayName: "Seafood"),
    FoodItem(category: .donuts,     image: UIImage(named: "Donut")!,     displayName: "Donut Shops"),
    FoodItem(category: .candy,      image: UIImage(named:  "Candy")!,    displayName: "Candy Stores"),
    FoodItem(category: .chicken,    image: UIImage(named: "Chicken")!,   displayName: "Chicken Wings"),
    FoodItem(category: .mexican,    image: UIImage(named: "Burrito")!,   displayName: "Mexican Food")
]

func getReadableDistance(meters: Double) -> String {
    // If less than 1/5 mile, return feet
    let units = SettingsManager.uints
    if meters < 804 {
        let feet = units == .imperial ? meters * 3.2808 : meters
        return "\(Int(round(feet))) \(units == .imperial ? "Feet" : "Meters")"
    } else {
        if units == .imperial {
            let miles = meters * 0.00062137
            return "\(Double(round(10*miles)/10)) Miles"
        } else {
            let kilometers = meters / 1000
            return "\(Double(round(10*kilometers)/10)) Km"
        }
    }
}

func localize(str: String) -> String {
    return NSLocalizedString(str, comment: "")
}

// MARK: Settings Manager
class SettingsManager {
    private struct UserDefaultsKeys {
        static let UNITS = "units"
        static let RADIUS = "radius"
    }
    
    public static var uints: UnitType {
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
        if self.uints == .imperial {
            return radius
        } else {
            return Int(round(Double(radius)*1.609344))
        }
    }
    
    public static var radiusInMeters: Double {
        return Double(self.radius)/0.00062137
    }
    
    public static func metersToUnits(meters: Double) -> Double {
        if self.uints == .imperial {
            return meters *  0.00062137
        } else {
            return meters/1000
        }
    }
    
    init() {
        // Register User Defaults on first launch
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.UNITS: UnitType.imperial.rawValue,
            UserDefaultsKeys.RADIUS: 2,
        ])
    }
}

enum UnitType: String {
    case imperial = "imperial"
    case metric = "metric"
}

// MARK: UIColor
extension UIColor {
    @nonobjc static var themeRed: UIColor { return #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1) }
    @nonobjc static var backgroundGray: UIColor { return #colorLiteral(red: 0.9725490196, green: 0.9607843137, blue: 0.9607843137, alpha: 1) }
}

// MARK: Core Location
public extension CLLocation {
  func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
    
    let lat1 = self.coordinate.latitude.degreesToRadians
    let lon1 = self.coordinate.longitude.degreesToRadians
    
    let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
    let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return CGFloat(radiansBearing)
  }
  
  func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
    return bearingToLocationRadian(destinationLocation).radiansToDegrees
  }
}

// MARK: CGFloat
extension CGFloat {
  var degreesToRadians: CGFloat { return self * .pi / 180 }
  var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

// MARK: Double
private extension Double {
  var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
  var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}
