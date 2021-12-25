//
//  FoodCompassStyler.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/7/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import Foundation
import UIKit

enum ButtonSize {
    case standard
    case large
}

class FoodCompassStyler {
    
    // MARK: Constants
    public static let mainCornerRadius: CGFloat = 15
    public static let buttonCornerRadius: CGFloat = 15
    public static let largeButtonCornerRadius: CGFloat = 20
    
    struct CollectionViewStyles {
        static let minimumLineSpacing = 16.0
        static let minimumInteritemSpacing = 4.0
        static let width = 73.0
        static let height = 73.0
    }
    
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
        cell.backgroundColor = .backgroundGray
        cell.layer.cornerRadius = mainCornerRadius
    }
    
    public static func stylePillButton(button: UIButton, buttonSize: ButtonSize = .standard) {
        button.layer.cornerRadius = buttonSize == .standard ? buttonCornerRadius : largeButtonCornerRadius
    }
}
