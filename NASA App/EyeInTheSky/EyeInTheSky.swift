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
    
    var currentLocation: CLLocation?
    
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
    @IBOutlet weak var dateTakenLbl: UILabel!
    @IBOutlet weak var cloudCoverLbl: UILabel!
    
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Methdods
    func createEarthImageURL(with coordinate: CLLocationCoordinate2D) -> URL? {
        let latLong: (lat: Double, long: Double) = (lat: coordinate.latitude, long: coordinate.longitude)
        
        let nasaAPIString = "\(APIService.nasaURL)\(NASATypes.eyeInTheSky.urlString)?&lon=\(latLong.long)&lat=\(latLong.lat)&cloud_score=True&api_key=\(APIService.apiKey)"
        
        guard let url: URL = URL(string: nasaAPIString) else { return nil }
        
        return url
    }
    
    func getPhoto() {
        guard let coordinate2d = self.currentLocation?.coordinate else { return }
        guard let url = createEarthImageURL(with: coordinate2d) else { return }
        
        JSONDownloader().downloadJSON(for: .eyeInTheSky, at: url, vc: self) { (locationData, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                self.generalAlert(title: "Error", message: "There was an error downloading your data. Please check your connection and try again.\n\nError: \(error.localizedDescription)")
                return
            }
            
            guard let data = locationData as? EarthImage else { SVProgressHUD.dismiss(); return }
            
            if let urlString = URL(string: data.url) {
                ImageService.getImage(withURL: urlString) { image in
                    self.imageView.image = image
                    self.dateTakenLbl.text = "Date Taken: \(data.date)"
                    
                    let cloudScore = Int((data.cloudScore * 100).rounded())
                    self.cloudCoverLbl.text = "Cloud Coverage: \(cloudScore)%"
                    
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
        let centerCoordinate = self.mapView.userLocation.coordinate
        
        SearchLocations.handleSearch(searchString: searchString, centerCoordinate: centerCoordinate) { (response, error) in
            guard let response = response else { return }
            self.mapItems = response.mapItems
        }
        
    }
    
}
