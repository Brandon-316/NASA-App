//
//  LocationManager.swift
//  Proximity Reminders App
//
//  Created by Brandon Mahoney on 7/3/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManger: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static let sharedInstance = LocationManger()
    
    
}
