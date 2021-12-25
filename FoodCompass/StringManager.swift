//
//  StringManager.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/13/21.
//  Copyright © 2021 Mitchell Sweet. All rights reserved.
//

import Foundation

struct StringManager {
    
    static let appTitle = "Food Compass"
    
    // MARK: - Errors
    struct Errors {
        static let error = "Error"
        static let restaurantSearch = "An error has occured when searching for restaurants. Please try again."
    }
    
    // MARK: - Buttons
    struct Buttons {
        static let cancel = "Cancel"
        static let skip = "Skip".localizedString
        static let results = "Results".localizedString
    }
    
    // MARK: - CompassViewController
    struct Compass {
        static let ratingPlaceholder = "Rating: --/--"
        static let infoPlaceholder = "----"
        static let noRestaurantsFound = "No Restaurants Found"
        static let tryAnotherCat = "Try another category!"
        
        static func nearYou(businessName: String) -> String {
            return "\(businessName) Near You"
        }
        
        static func rating(rating: Double, reviews: Int) -> String {
            return "Rating: \(rating)/5, \(reviews) Reviews"
        }
    }
    
    // MARK: - FoodViewController
    struct Food {
        static let hungry = "What are you hungry for?"
        static let poweredBy = "Powered by Yelp"
    }
    
    // MARK: - ListViewController
    struct List {
        static let map = "Map"
        static let list = "List"
        
        static func rating(rating: Double) -> String {
            return "Rating: \(rating)/5"
        }
        
        static func ratingReviews(rating: Double, reviewCount: Int) -> String {
            return "Rating: \(rating), \(reviewCount) Reviews"
        }
    }
    
    // MARK: - SettingsViewController
    struct Settings {
        static let settings = "Settings"
        static let units = "Units"
        static let radius = "Radius"
        static let copyright = "Food Compass, Version 1.0. Copyright 2020"
        static let miles = "Miles"
        static let kilometers = "Kilometers"
        static let imperial = "Imperial"
        static let metric = "Metric"
    }
}
