//
//  ViewController.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/3/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    // MARK: Constants
    private let cellIdentifier = "foodSelectionCell"
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestAuthorization()
        collectionViewSetup()
        localization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func localization() {
        titleLabel.text = localize(str: "Food_Compass")
        subtitleLabel.text = localize(str: "Hungry_Key")
        creditLabel.text = localize(str: "Powered")
    }
    
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
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 73, height: 73)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FoodItemCell
        
        cell.backgroundColor = .backgroundGray
        cell.layer.cornerRadius = 15
        cell.foodImageView.image = foodItems[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCompassWith(foodItem: foodItems[indexPath.row])
    }
    
    func showCompassWith(foodItem: FoodItem) {
        let compassVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: CompassViewController.storyboardID) as! CompassViewController
        compassVC.foodItem = foodItem
        self.navigationController?.pushViewController(compassVC, animated: true)
    }
    
    func showSettingsActionSheet() {
        let cancelActionButton = UIAlertAction(title: "Dismiss", style: .cancel)
        let informationActionButton = UIAlertAction(title: "Information", style: .default)
        { _ in
            let InfoVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: InfoViewController.storyboardID) as! InfoViewController
            self.navigationController?.pushViewController(InfoVC, animated: true)
        }
        let settingsActionButton = UIAlertAction(title: "Settings", style: .default)
        { _ in
            let settingVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: SettingsViewController.storyboardID) as! SettingsViewController
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
        let actionSheet: UIAlertController = UIAlertController(title: "Food Compass Settings", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(settingsActionButton)
        actionSheet.addAction(cancelActionButton)
        actionSheet.addAction(informationActionButton)
        
        self.present(actionSheet, animated: true)
    }
    
    // MARK: IBActions
    @IBAction func settingsButtonTapped() { showSettingsActionSheet() }
    
}
