//
//  RestaurantCell.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/7/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    // MARK: Constants
    public static let nibName = "RestaurantCell"
    public static let identifier = "restaurantcell"
    public static let defaultHeight: CGFloat = 114
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FoodCompassStyler.styleRestaurantCell(cell: self)
    }
    
    /// Sets cell data to past in business data
    public func assign(restaurant: Business) {
        nameLabel.text = restaurant.name
        ratingLabel.text = StringManager.List.ratingReviews(rating: restaurant.rating, reviewCount: restaurant.review_count)
        distanceLabel.text = getReadableDistance(meters: restaurant.distance)
        if let price = restaurant.price {
            ratingLabel.text = "\(ratingLabel.text!), \(price)"
        }
    }
}
