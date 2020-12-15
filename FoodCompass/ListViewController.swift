//
//  ListViewController.swift
//  FoodCompass
//
//  Created by Nicholas Pascucci on 12/3/20.
//  Copyright © 2020 Nicholas Pascucci. All rights reserved.
//

import UIKit
import MapKit

protocol ListControllerDelegate {
    // TODO: This is an okay implementation for now, but it introduces a bit of unnecessary
    // Future implementation should pass a restaurant object back instead of an index
    func restaurantSelected(index: Int)
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var modeSelection: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationCenterButton: UIButton!
    
    // MARK: Constants
    public static let storyboardID = "listVC"
    
    // MARK: Variables
    var restaurants = [Business]()
    var delegate: ListControllerDelegate?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeation()
        viewSetup()
        mapViewSetup()
        populateMap()
        tableViewSetup()
    }
    
    func viewSetup() {
        tableView.isHidden = true
        mapView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mapView.layer.cornerRadius = FoodCompassStyler.mainCornerRadius
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationCenterButton)
    }
    
    func localizeation() {
        modeSelection.setTitle(localize(str: "Map"), forSegmentAt: 0)
        modeSelection.setTitle(localize(str: "List"), forSegmentAt: 1)
    }
    
    func showMapView() {
        mapView.isHidden = false
        tableView.isHidden = true
        locationCenterButton.isHidden = false
    }
    
    func showListView() {
        mapView.isHidden = true
        tableView.isHidden = false
        locationCenterButton.isHidden = true
    }
    
    // MARK: MKMapViewDelegate
    func mapViewSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        let defaultLocation = CLLocationCoordinate2D(latitude: restaurants[0].coordinates.latitude, longitude: restaurants[0].coordinates.longitude)
        mapView.setCenter(CLLocationCoordinate2D(latitude: LocationManager.shared.latitude ?? defaultLocation.latitude, longitude: LocationManager.shared.longitude ?? defaultLocation.longitude), animated: true)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: LocationManager.shared.latitude ?? defaultLocation.latitude, longitude: LocationManager.shared.longitude ?? defaultLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10))
        mapView.setRegion(region, animated: true)
    }
    
    func populateMap() {
        mapView.removeAnnotations(mapView.annotations)
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.subtitle = "Rating: \(restaurant.rating)/5"
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView?.tintColor = .themeRed
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let index = restaurants.firstIndex(where: { $0.name == view.annotation?.title} )
        if let index = index {
            delegate?.restaurantSelected(index: index)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func centerLocation() {
        let defaultLocation = CLLocationCoordinate2D(latitude: restaurants[0].coordinates.latitude, longitude: restaurants[0].coordinates.longitude)
        mapView.setCenter(CLLocationCoordinate2D(latitude: LocationManager.shared.latitude ?? defaultLocation.latitude, longitude: LocationManager.shared.longitude ?? defaultLocation.longitude), animated: true)
    }
    
    // MARK: UITableViewDelegate
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: RestaurantCell.nibName, bundle: nil), forCellReuseIdentifier: RestaurantCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RestaurantCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.identifier, for: indexPath) as! RestaurantCell
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        cell.ratingLabel.text = "Rating: \(restaurant.rating), \(restaurant.review_count) Reviews"
        if let price = restaurant.price {
            cell.ratingLabel.text = "\(cell.ratingLabel.text!), \(price)"
        }
        cell.distanceLabel.text = getReadableDistance(meters: restaurant.distance)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.restaurantSelected(index: indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: IBActions
    @IBAction func didChangeMode(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showMapView()
        } else if sender.selectedSegmentIndex == 1 {
            showListView()
        }
    }
    @IBAction func locationButtonTapped() { centerLocation() }
}
