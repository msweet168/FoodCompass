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
        static let error = "ERROR".localizedString
        static let restaurantSearch = "ERROR_MESSAGE".localizedString
    }
    
    // MARK: - Buttons
    struct Buttons {
        static let cancel = "CANCEL".localizedString
        static let skip = "SKIP".localizedString
        static let results = "RESULTS".localizedString
    }
    
    // MARK: - CompassViewController
    struct Compass {
        static let ratingPlaceholder = "RATING_PLACEHOLDER".localizedString
        static let infoPlaceholder = "----"
        static let noRestaurantsFound = "NOT_FOUND".localizedString
        static let tryAnotherCat = "TRY_AGAIN".localizedString
        
        static func nearYou(businessName: String) -> String {
            return "\(businessName) Near You"
        }
        
        static func rating(rating: Double, reviews: Int) -> String {
            return "Rating: \(rating)/5, \(reviews) Reviews"
        }
    }
    
    // MARK: - FoodViewController
    struct Food {
        static let hungry = "HUNGRY".localizedString
        static let poweredBy = "POWERED_BY".localizedString
    }
    
    // MARK: - ListViewController
    struct List {
        static let map = "MAP".localizedString
        static let list = "LIST".localizedString
        
        static func rating(rating: Double) -> String {
            return "Rating: \(rating)/5"
        }
        
        static func ratingReviews(rating: Double, reviewCount: Int) -> String {
            return "Rating: \(rating), \(reviewCount) Reviews"
        }
    }
    
    // MARK: - SettingsViewController
    struct Settings {
        static let settings = "SETTINGS".localizedString
        static let units = "UNITS".localizedString
        static let radius = "RADIUS".localizedString
        static let copyright = "Food Compass, Version 1.0. Copyright 2020"
        static let miles = "MILES".localizedString
        static let kilometers = "KILOMETERS".localizedString
        static let imperial = "IMPERIAL".localizedString
        static let metric = "METRIC".localizedString
    }
}
