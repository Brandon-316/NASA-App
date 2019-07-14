//
//  SetLocationTableView.swift
//  Proximity Reminders App
//
//  Created by Brandon Mahoney on 7/1/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class LocationTableView: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var setLocationVC: EyeInTheSkyVC
    var tableView: UITableView
    
    
    init(setLocationVC: EyeInTheSkyVC) {
        self.setLocationVC = setLocationVC
        self.tableView = setLocationVC.tableView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.setLocationVC.mapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.configureCell(with: self.setLocationVC.mapItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem: MKMapItem =  self.setLocationVC.mapItems[indexPath.row]
        let latitude = mapItem.placemark.coordinate.latitude
        let longitude = mapItem.placemark.coordinate.longitude
        let newLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.setLocationVC.currentLocation = newLocation
        self.setLocationVC.searchBar.endEditing(true)
        self.setLocationVC.centerViewOnUserLocation()
        self.setLocationVC.mapItems = []
        self.tableView.reloadData()
    }
    
}
