//
//  FoodCompassStyler.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/7/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import Foundation
import UIKit

class FoodCompassStyler {
    
    // MARK: Constants
    public static let mainCornerRadius: CGFloat = 15
    public static let buttonCornerRadius: CGFloat = 15
    
    // MARK: Functions
    public static func styleRestaurantCell(cell: RestaurantCell) {
        cell.topConstraint.constant = 5
        cell.bottomConstraint.constant = 5
        cell.leftConstraint.constant = 15
        cell.rightConstraint.constant = 15
        cell.mainView.backgroundColor = .backgroundGray
        cell.mainView.layer.cornerRadius = mainCornerRadius
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
    }
    
    public static func styleFoodItemCell(cell: FoodItemCell) {
        
    }
    
}
