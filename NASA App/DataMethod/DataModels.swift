//
//  DataModels.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/12/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation




protocol ObjectModel {}




//Mars Rover
struct RoverData: Codable, ObjectModel {
    var latestPhotos: [RoverImage]
}

struct RoverImage: Codable {
    var imgSrc: String
    var sol: Int
}




//Eye in the Sky
struct EarthImage: Codable, ObjectModel {
    var date: String
    var url: String
}
