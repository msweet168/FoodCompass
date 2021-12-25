//
//  Declarations.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/6/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Globals {
    static let StoryboardName = "Main"
}

// MARK: Food Items
let foodItems: [FoodItem] = [
    FoodItem(category: .coffee,     image: ImageManager.coffee,    displayName: "Coffee Shops"),
    FoodItem(category: .fastFood,   image: ImageManager.fries,     displayName: "Fast Food"),
    FoodItem(category: .icecream,   image: ImageManager.iceCream,  displayName: "Ice Cream"),
    FoodItem(category: .chinese,    image: ImageManager.chinese,   displayName: "Chinese Food"),
    FoodItem(category: .pancakes,   image: ImageManager.pancakes,  displayName: "Pancake Houses"),
    FoodItem(category: .italian,    image: ImageManager.pasta,     displayName: "Italian Food"),
    FoodItem(category: .pizza,      image: ImageManager.pizza,     displayName: "Pizza"),
    FoodItem(category: .salad,      image: ImageManager.salad,     displayName: "Salad"),
    FoodItem(category: .sushi,      image: ImageManager.sushi,     displayName: "Sushi"),
    FoodItem(category: .tacos,      image: ImageManager.taco,      displayName: "Tacos"),
    FoodItem(category: .tea,        image: ImageManager.tea,       displayName: "Tea Shops"),
    FoodItem(category: .sandwiches, image: ImageManager.sandwich,  displayName: "Sandwich Shops"),
    FoodItem(category: .bars,       image: ImageManager.beer,      displayName: "Bars"),
    FoodItem(category: .hotdog,     image: ImageManager.hotDog,    displayName: "Hot Dogs"),
    FoodItem(category: .grocery,    image: ImageManager.groceries, displayName: "Grocery Stores"),
    FoodItem(category: .seafood,    image: ImageManager.fish,      displayName: "Seafood"),
    FoodItem(category: .donuts,     image: ImageManager.donut,     displayName: "Donut Shops"),
    FoodItem(category: .candy,      image: ImageManager.candy,     displayName: "Candy Stores"),
    FoodItem(category: .chicken,    image: ImageManager.chicken,   displayName: "Chicken Wings"),
    FoodItem(category: .mexican,    image: ImageManager.burrito,   displayName: "Mexican Food")
]

func getReadableDistance(meters: Double) -> String {
    // If less than 1/2 mile, return feet
    let units = SettingsManager.units
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

var statusBarOrientation: UIInterfaceOrientation? {
    get {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return nil }
        return orientation
    }
}

enum UnitType: String, CaseIterable {
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

// MARK: String
extension String {
    var localizedString: String { return NSLocalizedString(self, comment: "") }
}
