//
//  CompassViewController.swift
//  FoodCompass
//
//  Created by Mitchell Sweet on 12/3/20.
//  Copyright © 2020 Mitchell Sweet. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CompassViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var restaurantTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var openInMapsButton: UIButton!
    
    // MARK: Constants
    public static let storyboardID = "compassVC"
    
    // MARK: Variables
    var loadingSpinner: UIActivityIndicatorView?
    var foodItem: FoodItem!
    var restaurants = [Business]()
    var currentRestaurant = 0
    
    private var latestLocation: CLLocation? = nil
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.setDelegate(delegate: self)
        
        viewSetup()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func viewSetup() {
        self.navigationController?.navigationBar.tintColor = .themeRed
        self.title = StringManager.appTitle
        restaurantTitleLabel.text = foodItem.displayName
        categoryImageView.image = foodItem.image
        ratingLabel.text = StringManager.Compass.ratingPlaceholder
        infoLabel.text = StringManager.Compass.infoPlaceholder
        distanceLabel.isHidden = true
        
        skipButton.setTitle(StringManager.Buttons.skip, for: .normal)
        listButton.setTitle(StringManager.Buttons.results, for: .normal)
        FoodCompassStyler.stylePillButton(button: skipButton, buttonSize: .large)
        FoodCompassStyler.stylePillButton(button: listButton, buttonSize: .large)
        
        loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner?.color = .themeRed
        loadingSpinner?.hidesWhenStopped = true
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: openInMapsButton!),
                                                   UIBarButtonItem(customView: loadingSpinner!)]
    }
    
    func getData() {
        startLoading()
        API.shared.searchYelpFor(category: foodItem!.category) { [weak self] (results, error) in
            self?.stopLoading()
            guard error == nil else {
                // TODO: Implement better error handling
                let errorAlert = UIAlertController(title: StringManager.Errors.error,
                                                   message: StringManager.Errors.restaurantSearch,
                                                   preferredStyle: UIAlertController.Style.alert)
                errorAlert.addAction(UIAlertAction(title: StringManager.Buttons.cancel,
                                                   style: .cancel,
                                                   handler: { (action: UIAlertAction!) in }))
                
                self?.present(errorAlert, animated: true, completion: nil)

                self?.listButton.isEnabled = false
                self?.skipButton.isEnabled = false
                self?.openInMapsButton.isEnabled = false

                return
            }
            
            guard let res = results else { return }
            self?.restaurants = res.businesses
            self?.loadRestaurant()
        }
    }
    
    func loadRestaurant() {
        guard restaurants.count > 0 else {
            print("No restaurants found...")
            restaurantTitleLabel.text = StringManager.Compass.noRestaurantsFound
            ratingLabel.text = StringManager.Compass.tryAnotherCat
            infoLabel.isHidden = true
            arrowImage.isHidden = true
            skipButton.isHidden = true
            listButton.isHidden = true
            distanceLabel.isHidden = true
            openInMapsButton.isHidden = true
            return
        }
        
        let current = restaurants[currentRestaurant]
        
        restaurantTitleLabel.text = current.name
        distanceLabel.isHidden = false
        distanceLabel.text = getReadableDistance(meters: current.distance)
        ratingLabel.text = StringManager.Compass.rating(rating: current.rating, reviews: current.review_count)
        infoLabel.text = ""
        if let price = current.price {
            infoLabel.text = "\(price)"
        }
        
        updateHeading(with: LocationManager.shared.heading ?? 0.0)
    }
    
    func refreshDistance() {
        guard restaurants.count > 0,
              restaurants.count >= currentRestaurant else { return }
        let current = restaurants[currentRestaurant]
        let restaurantLocation = CLLocation(latitude: current.coordinates.latitude, longitude: current.coordinates.longitude)
        let distance = latestLocation?.distance(from: restaurantLocation)
        if let distance = distance {
            distanceLabel.text = getReadableDistance(meters: distance)
        }
    }
    
    func nextRestaurant() {
        if currentRestaurant == restaurants.count-1 {
            currentRestaurant = 0
        } else {
            currentRestaurant += 1
        }
        loadRestaurant()
    }
    
    func openCurrentInMaps() {
        guard restaurants.count > 0 else { return }

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(restaurants[currentRestaurant].coordinates.latitude, restaurants[currentRestaurant].coordinates.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurants[currentRestaurant].name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func startLoading() { loadingSpinner?.startAnimating() }
    func stopLoading() { loadingSpinner?.stopAnimating() }
    
    // MARK: IBActions
    @IBAction func skipTapped() { nextRestaurant() }
    
    @IBAction func showAllResultsTapped() {
        guard restaurants.count > 0 else { return }

        let listVC = UIStoryboard.init(name: Globals.StoryboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: ListViewController.storyboardID) as! ListViewController
        listVC.restaurants = restaurants
        listVC.title = StringManager.Compass.nearYou(businessName: foodItem.displayName)
        listVC.delegate = self
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func openInMapsTapped() { openCurrentInMaps() }
    
    // MARK: - Compass
    // Compass was created using this tutorial: https://www.fivestars.blog/code/build-compass-app-swift.html
    
    private var locationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.targetLocation) ?? 0 }
    private var targetLocation: CLLocation {
        get {
            return CLLocation(latitude: restaurants[currentRestaurant].coordinates.latitude,
                              longitude: restaurants[currentRestaurant].coordinates.longitude)
            
        }
    }
    
    private func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
        var heading = locationBearing - newAngle.degreesToRadians
        if UIDevice.current.orientation == .faceDown { heading *= -1 }
        
        return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
    }
    
    private func orientationAdjustment() -> CGFloat {
        var angle = 0.0
        
        if statusBarOrientation == .portraitUpsideDown {
            angle = UIDevice.current.orientation == .faceDown ? 180 : -180
        }

        return angle
    }
    
    func updateHeading(with heading: CLLocationDirection) {
        guard !restaurants.isEmpty else { return }
        
        let angle = self.computeNewAngle(with: heading)
        UIView.animate(withDuration: 0.5) {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}

extension CompassViewController: ListControllerDelegate {
    
    func restaurantSelected(index: Int) {
        currentRestaurant = index
        loadRestaurant()
    }
}

extension CompassViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.latestLocation = currentLocation
        refreshDistance()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateHeading(with: newHeading.trueHeading)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: Updating location " + error.localizedDescription)
    }
}
