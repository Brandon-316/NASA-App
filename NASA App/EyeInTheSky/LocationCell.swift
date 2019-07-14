//
//  LocationCell.swift
//  Proximity Reminders App
//
//  Created by Brandon Mahoney on 7/2/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class LocationCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    func configureCell(with object: MKMapItem) {
        self.mainLabel.text = object.name
        self.setAddressLabel(with: object.placemark)
    }
    
    func setAddressLabel(with placemark: CLPlacemark) {
        var addressString: String = ""
        
        if let buildingNumber = placemark.subThoroughfare {
            addressString = addressString + buildingNumber + " "
        }
        if let street = placemark.thoroughfare {
            addressString = addressString + street + ", "
        }
        if let city = placemark.locality {
            addressString = addressString + city + ", "
        }
        if let state = placemark.administrativeArea {
            addressString = addressString + state + " "
        }
        
        self.addressLabel.text = addressString
        
    }
    
}
