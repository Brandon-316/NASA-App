//
//  NASARequestTypes.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/12/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation



enum NASATypes {
    case marsRover
    case eyeInTheSky
    
    
    var urlString: String {
        switch self {
        case .marsRover: return "mars-photos/api/v1/rovers/"
        case .eyeInTheSky: return "planetary/earth/imagery/"
        }
    }
}
