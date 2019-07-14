//
//  Planets.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/10/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation


enum Planets: String, CaseIterable {
    case earthDay = "Earth Day"
    case earthNight = "Earth Night"
    case jupiter = "Jupiter"
    case mars = "Mars"
    case mercury = "Mercury"
    case moon = "Moon"
    case neptune = "Neptune"
    case saturn = "Saturn"
    case sun = "Sun"
    case venusAtmosphere = "Venus"
    case venusSurface = "Venus Surface"
    case uranus = "Uranus"
    
    
    var sceneName: String {
        
        let artExt: String = "art.scnassets/"
        
        switch self {
        case .earthDay: return "\(artExt)8k_Earth_DayMap.jpg"
        case .earthNight: return "\(artExt)8k_Earth_NightMap.jpg"
        case .jupiter: return "\(artExt)8k_Jupiter.jpg"
        case .mars: return "\(artExt)8k_Mars.jpg"
        case .mercury: return "\(artExt)8k_Mercury.jpg"
        case .moon: return "\(artExt)8k_Moon.jpg"
        case .neptune: return "\(artExt)2k_Neptune.jpg"
        case .saturn: return "\(artExt)8k_Saturn.jpg"
        case .sun: return "\(artExt)8k_Sun.jpg"
        case .venusAtmosphere: return "\(artExt)8k_Venus_Atmosphere.jpg"
        case .venusSurface: return "\(artExt)8k_Venus_Surface.jpg"
        case .uranus: return "\(artExt)2k_Uranus.jpg"
        }
    }
}
