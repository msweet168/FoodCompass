//
//  ImageManager.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/13/21.
//  Copyright © 2021 Mitchell Sweet. All rights reserved.
//

import Foundation
import UIKit

struct ImageManager {
    
    // MARK: - System Images
    static let defaultImage = UIImage(systemName: "questionmark.square.dashed")!
    static let archiveBox =   systemImg(name: "archivebox.fill")
    static let bell =         systemImg(name: "bell.fill")
    
    // MARK: - Asset Images
    static let coffee =     assetImage(name: "Coffee")
    static let fries =      assetImage(name: "Fries")
    static let iceCream =   assetImage(name: "Ice Cream")
    static let chinese =    assetImage(name: "Chinese")
    static let pancakes =   assetImage(name: "Pancakes")
    static let pasta =      assetImage(name: "Pasta")
    static let pizza =      assetImage(name: "Pizza")
    static let salad =      assetImage(name: "Salad")
    static let sushi =      assetImage(name: "Sushi")
    static let taco =       assetImage(name: "Taco")
    static let tea =        assetImage(name: "Tea")
    static let sandwich =   assetImage(name: "Sandwich")
    static let beer =       assetImage(name: "Beer")
    static let hotDog =     assetImage(name: "Hot Dog")
    static let groceries =  assetImage(name: "Groceries")
    static let fish =       assetImage(name: "Fish")
    static let donut =      assetImage(name: "Donut")
    static let candy =      assetImage(name: "Candy")
    static let chicken =    assetImage(name: "Chicken")
    static let burrito =    assetImage(name: "Burrito")
    
    public static func systemImg(name: String) -> UIImage {
        return UIImage(systemName: name) ?? defaultImage
    }
    
    public static func assetImage(name: String) -> UIImage {
        return UIImage(named: name) ?? defaultImage
    }
}
