//
//  CompassViewController.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/3/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CompassViewController: UIViewController, ListControllerDelegate {
    
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
    let locationDelegate = LocationDelegate()
    
    // MARK: Variables
    var loadingSpinner: UIActivityIndicatorView?
    var foodItem: FoodItem?
    var restaurants = [Business]()
    var currentRestaurant = 0
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard foodItem != nil else {
            // TOOD: Handle empty category error
            return
        }
        
        localization()
        viewSetup()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func viewSetup() {
        self.navigationController?.navigationBar.tintColor = .themeRed
        self.title = "Food Compass"
        restaurantTitleLabel.text = foodItem!.displayName
        categoryImageView.image = foodItem!.image
        ratingLabel.text = "Rating: --/--"
        infoLabel.text = "----"
        skipButton.layer.cornerRadius = 20
        listButton.layer.cornerRadius = 20
        distanceLabel.isHidden = true
        
        loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner?.color = .themeRed
        loadingSpinner?.hidesWhenStopped = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingSpinner!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: openInMapsButton!)
    }
    
    func localization() {
        skipButton.setTitle(localize(str: "Skip"), for: .normal)
        listButton.setTitle(localize(str: "Results"), for: .normal)
    }
    
    
    func getData() {
        startLoading()
        API.shared.searchYelpFor(category: foodItem!.category) { (results, error) in
            self.stopLoading()
            guard error == nil else {
                // TODO: Implement better error handling
                let errorAlert = UIAlertController(title: "Error", message: "An error has occured when searching for restaurants. Please try again.", preferredStyle: UIAlertController.Style.alert)
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in }))

                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            guard let res = results else {
                // TODO: Handle error
                return
            }
            self.restaurants = res.businesses
            self.loadRestaurant()
            self.compassSetup()
        }
    }
    
    func loadRestaurant() {
        guard restaurants.count > 0 else {
            print("No restaurants found...")
            restaurantTitleLabel.text = "No Restaurants Found"
            ratingLabel.text = "Try another category"
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
        ratingLabel.text = "Rating: \(Int(current.rating))/5, \(current.review_count) Reviews"
        if let price = current.price {
            infoLabel.text = "\(price)"
        } else {
            infoLabel.text = ""
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
    
    func restaurantSelected(index: Int) {
        currentRestaurant = index
        loadRestaurant()
    }
    
    func openCurrentInMaps() {
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
        let listVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ListViewController.storyboardID) as! ListViewController
        listVC.restaurants = restaurants
        listVC.title = "\(foodItem?.displayName ?? "Restaurants") Near You"
        listVC.delegate = self
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func openInMapsTapped() { openCurrentInMaps() }
    
    // MARK: Messy Compass Code
    // Compass was created using this tutorial: https://www.fivestars.blog/code/build-compass-app-swift.html
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    var yourLocation: CLLocation {
        get { return CLLocation(latitude: restaurants[currentRestaurant].coordinates.latitude, longitude: restaurants[currentRestaurant].coordinates.longitude) }
    }
    
    let locationManager: CLLocationManager = {
      $0.requestWhenInUseAuthorization()
      $0.desiredAccuracy = kCLLocationAccuracyBest
      $0.startUpdatingLocation()
      $0.startUpdatingHeading()
      return $0
    }(CLLocationManager())
    
    private func orientationAdjustment() -> CGFloat {
      let isFaceDown: Bool = {
        switch UIDevice.current.orientation {
        case .faceDown: return true
        default: return false
        }
      }()
      
      let adjAngle: CGFloat = {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:  return 90
        case .landscapeRight: return -90
        case .portrait, .unknown: return 0
        case .portraitUpsideDown: return isFaceDown ? 180 : -180
        }
      }()
      return adjAngle
    }
    
    func compassSetup() {
        guard restaurants.count > 0 else { return }
        locationManager.delegate = locationDelegate
        
        locationDelegate.locationCallback = { location in
          self.latestLocation = location
        }
        
        locationDelegate.headingCallback = { newHeading in
          
          func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
            let heading: CGFloat = {
              let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
              switch UIDevice.current.orientation {
              case .faceDown: return -originalHeading
              default: return originalHeading
              }
            }()
            
            return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
          }
          
          UIView.animate(withDuration: 0.5) {
            let angle = computeNewAngle(with: CGFloat(newHeading))
            self.arrowImage.transform = CGAffineTransform(rotationAngle: angle)
          }
        }
    }
}
