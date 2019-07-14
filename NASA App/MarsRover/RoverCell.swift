//
//  RoverCell.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/11/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


class RoverCell: UICollectionViewCell {
    
    @IBOutlet weak var roverImageView: UIImageView!
    
    
    func configure(with rover: RoverImage) {
        if let urlString = URL(string: rover.imgSrc) {
            self.roverImageView.image = nil
            ImageService.getImage(withURL: urlString) { image in
                self.roverImageView.image = image
            }
        }
    }
    
}
