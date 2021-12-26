//
//  FoodViewController.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/3/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import UIKit
import CoreLocation

class FoodViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.setDelegate(delegate: self)
        viewSetup()
        collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func viewSetup() {
        titleLabel.text = StringManager.appTitle
        subtitleLabel.text = StringManager.Food.hungry
        creditLabel.text = StringManager.Food.poweredBy
    }
    
    func showCompassWith(foodItem: FoodItem) {
        let compassVC = UIStoryboard.init(name: Globals.StoryboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: CompassViewController.storyboardID) as! CompassViewController
        compassVC.foodItem = foodItem
        self.navigationController?.pushViewController(compassVC, animated: true)
    }
    
    func showSettings() {
        let settingVC = UIStoryboard.init(name: Globals.StoryboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: SettingsViewController.storyboardID) as! SettingsViewController
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // MARK: IBActions
    @IBAction func settingsButtonTapped() { showSettings() }
}

extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDelegate
    func collectionViewSetup() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FoodCompassStyler.CollectionViewStyles.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FoodCompassStyler.CollectionViewStyles.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FoodCompassStyler.CollectionViewStyles.width,
                      height: FoodCompassStyler.CollectionViewStyles.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodItemCell.identifier, for: indexPath) as! FoodItemCell
        
        FoodCompassStyler.styleFoodItemCell(cell: cell)
        cell.foodImageView.image = foodItems[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCompassWith(foodItem: foodItems[indexPath.row])
    }
}

extension FoodViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        LocationManager.shared.setupLocationManager()
    }
}
