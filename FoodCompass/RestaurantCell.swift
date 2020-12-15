//
//  RestaurantCell.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/7/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
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
}
