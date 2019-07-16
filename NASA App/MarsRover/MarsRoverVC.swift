//
//  MarsRoverVC.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/11/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import SVProgressHUD


class MarsRoverVC: UIViewController {
    
    var rovers: [String] = []
    
    let roverBtn: UIButton = UIButton(type: .system)
    let roverDropDown: DropDown = DropDown()
    var currentSelectedRover: Rovers = .curiosity {
        didSet {
            self.roverBtn.setTitle(currentSelectedRover.title, for: .normal)
            self.downloadRoverData()
        }
    }
    
    lazy var dataSource: RoverCollectionView = {
        return RoverCollectionView(marsRoverVC: self)
    }()
    
    var roverData: RoverData?
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var solLabel: UILabel!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        setCellSize()
        
        createRoversArray()
        setRoverButton()
        setupRoverDropDown()
        
        downloadRoverData()
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePostcardSegue" {
            guard let navController = segue.destination as? UINavigationController else { return }
            guard let createPostcardVC = navController.topViewController as? CreatePostcardVC else { return }
            
            if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
                guard let cell = self.collectionView.cellForItem(at: indexPath) as? RoverCell else { return }
                createPostcardVC.image = cell.roverImageView.image
            }
        }
    }
    
    //MARK: - Methods
    //Create array used for dropdown menu
    func createRoversArray() {
        for rover in Rovers.allCases {
            rovers.append(rover.rawValue)
        }
    }
    
    func setRoverButton() {
        roverBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        roverBtn.backgroundColor = .clear
        roverBtn.setTitleColor(.white, for: .normal)
        roverBtn.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        roverBtn.setTitle(currentSelectedRover.title, for: .normal)
        roverBtn.addTarget(self, action: #selector(toggleDropDown), for: .touchUpInside)
        navigationItem.titleView = roverBtn
    }
    
    func setupRoverDropDown() {
        roverDropDown.anchorView = roverBtn
        
        roverDropDown.bottomOffset = CGPoint(x: 0, y: roverBtn.bounds.height)
        
        roverDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            // Setup your custom UI components
            cell.optionLabel.textAlignment = .center
        }
        
        roverDropDown.dataSource = rovers
        
        roverDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.currentSelectedRover = Rovers(rawValue: item)!
        }
        
        roverDropDown.dismissMode = .onTap
        
        
    }
    
    @objc func toggleDropDown() {
        roverDropDown.show()
    }
    
    //Adjust size of cell to ensure that each row contains 3 equally spaced cells
    func setCellSize() {
        //Get size of width of device screen
        let width = view.frame.width
        //Get width minus separations
        let reducedWidth = width - 32
        var cellSpan = reducedWidth / 3
        cellSpan.round(.down)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellSpan, height: cellSpan)
    }
    
    //Download data for selected rover
    func downloadRoverData() {
        JSONDownloader().downloadJSON(for: .marsRover, rover: self.currentSelectedRover, vc: self) { roverData, error in
            
            if let error = error {
                SVProgressHUD.dismiss()
                self.generalAlert(title: "Error", message: "There was an error downloading your data. Please check your connection and try again.\n\nError: \(error.localizedDescription)")
                return
            }
            
            guard let data = roverData as? RoverData else { SVProgressHUD.dismiss(); return }
            self.roverData = data
            
            DispatchQueue.main.async {
                guard let firstObject = self.roverData?.latestPhotos.first else { SVProgressHUD.dismiss(); return }
                self.solLabel.text = "Sol: \(firstObject.sol)"
                SVProgressHUD.dismiss()
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
