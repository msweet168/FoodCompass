//
//  API.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/4/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import Foundation

struct Keys {
    static let API_KEY = "DyWTsp2-9XneDlpPrhCfN4Wr_5S4EFQniy_tMtumgIvPR5ig6m-uJAjRjAdahQ27HKp6ggB0fyUPqxPSa3luW0pqA77n6rsrR6qc672BBdNNzF_G7AwevUcImalfW3Yx"
}

/// Corisponds to business category name in Yelp API
enum RestaurantCategory: String {
    case coffee = "coffee"
    case fastFood = "hotdogs"
    case icecream = "icecream"
    case chinese = "chinese"
    case pancakes = "pancakes"
    case italian = "italian"
    case pizza = "pizza"
    case salad = "salad"
    case sushi = "sushi"
    case tacos = "tacos"
    case tea = "tea"
    case sandwiches = "sandwiches"
    case bars = "bars"
    case hotdog = "hotdog"
    case grocery = "grocery"
    case seafood = "seafood"
    case donuts = "donuts"
    case candy = "candy"
    case chicken = "chicken_wings"
    case mexican = "mexican"
}

enum APIError: Error {
    case locationError
    case parseError
    case internetError
    case apiError
    case unknown
}

class API {
    // MARK: Constants
    public static let shared = API()
    private let address = "https://api.yelp.com/v3/businesses/search"
    
    // MARK: Functions    
    public func searchYelpFor(category: RestaurantCategory, completion: @escaping (SearchResults?, APIError?) -> Void) {

        LocationManager.shared.refreshLocation()

        guard let lat = LocationManager.shared.latitude,
              let long = LocationManager.shared.longitude else {
                  print("Location is not available for API call...")
                  completion(nil, .locationError)
                  return
              }

        var urlString = "\(address)?latitude=\(lat)&longitude=\(long)&categories=\(category.rawValue)&sort_by=distance"
        if !SettingsManager.showClosed { urlString += "&open_now=true"}
        urlString += "&radius=\(Int(SettingsManager.radiusInMeters))"
        
        let url = URL(string: urlString)!
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["Authorization": "Bearer \(Keys.API_KEY)"]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("ERROR searching yelp: \(error?.localizedDescription ?? "N/A")")
                DispatchQueue.main.async { completion(nil, .apiError) }
                return
            }
            
            do {
                let res = try JSONDecoder().decode(SearchResults.self, from: data)
                DispatchQueue.main.async { completion(res, nil) }
            } catch let error {
                print("ERROR parsing data: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil, .parseError) }
            }
        }
        task.resume()
    }
}
