//
//  SearchLocations.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/15/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import MapKit


class SearchLocations {
    
    static func handleSearch(searchString: String, centerCoordinate: CLLocationCoordinate2D, completion: @escaping(MKLocalSearch.Response?, Error?) -> ()) {
        var region = MKCoordinateRegion()
        region.center = centerCoordinate
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            completion(response, error)
        }
    }
}


