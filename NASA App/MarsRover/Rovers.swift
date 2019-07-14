//
//  Rovers.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/11/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation


enum Rovers: String, CaseIterable {
    case curiosity = "curiosity"
    case opportunity = "opportunity"
    case spirit = "spirit"
    
    var title: String {
        switch self {
            case .curiosity: return "Curiosity"
            case .opportunity: return "Opportunity"
            case .spirit: return "Spirit"
        }
    }
}
