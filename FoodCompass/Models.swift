//
//  Models.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/4/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import Foundation
import UIKit

struct FoodItem {
    let category: RestaurantCategory
    let image: UIImage
    let displayName: String
}

struct SearchResults: Codable {
    let businesses: [Business]
    let total: Int
}

struct Business: Codable {
    let name: String
    let rating: Double
    let price: String?
    let id: String
    let is_closed: Bool
    let review_count: Int
    let coordinates: Coordinate
    let distance: Double
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}
