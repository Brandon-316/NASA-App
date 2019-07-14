//
//  EyeInTheSky.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/12/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SVProgressHUD


class EyeInTheSkyVC: UIViewController {
    
    //MARK: - Properties
    lazy var locationTableView: LocationTableView = {
        return LocationTableView(setLocationVC: self)
    }()
    
    //Map properties
    let locationManager:CLLocationManager = LocationManger.sharedInstance.locationManager
    let regionInMeters: Double = 2000
    var previousLocation: CLLocation?
    
    var currentLocation: CLLocation? {
        didSet {
            guard let coordinate2D = self.currentLocation?.coordinate else { return }
            print("\nLatitude: \(coordinate2D.latitude)\nLongitude: \(coordinate2D.longitude)")
        }
    }
    
    var mapItems: [MKMapItem] = [] {
        didSet {
            self.tableView.reloadData()
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self.locationTableView
        self.tableView.delegate = self.locationTableView
        self.tableViewHeight.constant = self.tableView.contentSize.height
        self.searchBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkLocationServices()
    }
    
    
    //MARK: - Methdods
    func getPhoto() {
        print("getPhoto tapped")
        guard let lat = self.currentLocation?.coordinate.latitude, let long = self.currentLocation?.coordinate.longitude else { print("return 1"); return }
        let latLong: (lat: Double, long: Double) = (lat: lat, long: long)
        
        JSONDownloader().downloadJSON(for: .eyeInTheSky, latLong: latLong, vc: self) { (locationData, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                self.generalAlert(title: "Error", message: "There was an error downloading your data. Please check your connection and try again.\n\nError: \(error.localizedDescription)")
                return
            }
            
            guard let data = locationData as? EarthImage else { SVProgressHUD.dismiss(); return }
            
            if let urlString = URL(string: data.url) {
                ImageService.getImage(withURL: urlString) { image in
                    self.imageView.image = image
                    SVProgressHUD.dismiss()
                }
            }
            
        }
    }
    
    
    //MARK: - Actions
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getImage(_ sender: Any) {
        getPhoto()
    }
    
}



//MARK: - SearchBarDelegate
extension EyeInTheSkyVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = self.searchBar.text {
            if !searchString.isEmpty {
                self.populateNearByPlaces(searchString: searchString)
            } else {
                self.mapItems.removeAll()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.populateNearByPlaces(searchString: searchText)
        } else {
            self.mapItems.removeAll()
        }
    }
    
    
}


//MARK: - Handle Search
extension EyeInTheSkyVC {
    
    func populateNearByPlaces(searchString: String) {
        
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response else {
                return
            }
            
            self.mapItems = response.mapItems
            
            
            
        }
    }
    
}
