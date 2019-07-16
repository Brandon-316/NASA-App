//
//  RoverCollectionView.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/11/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit

class RoverCollectionView: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Properties
    private let marsRoverVC: MarsRoverVC
    let reuseIdentifier: String = "RoverCell"
    var isInitialLoad: Bool = true
    
    //Initializer
    init(marsRoverVC: MarsRoverVC) {
        self.marsRoverVC = marsRoverVC
    }
    
    //Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let objectCount = marsRoverVC.roverData?.latestPhotos.count ?? 0
        
        if objectCount == 0 && self.isInitialLoad == false {
            self.marsRoverVC.collectionView.setEmptyView(title: "No Images returned", message: "Sorry but no images exist for this Sol.")
        } else {
            self.marsRoverVC.collectionView.restore()
            self.isInitialLoad = false
        }
        
        return objectCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = marsRoverVC.collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoverCell
        guard let roverImage = marsRoverVC.roverData?.latestPhotos[indexPath.row] else { return  cell }
        cell.configure(with: roverImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        marsRoverVC.performSegue(withIdentifier: "CreatePostcardSegue", sender: nil)
    }
    
    
    
    
}

