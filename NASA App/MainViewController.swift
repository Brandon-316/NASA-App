//
//  ViewController.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/9/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    //MARK: - Properties
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    //MARK: - Outlets
    @IBOutlet weak var roverPostcardBtn: UIButton!
    @IBOutlet weak var planetaryARBtn: UIButton!
    @IBOutlet weak var eyeInTheSkyBtn: UIButton!
    
    @IBOutlet weak var marsRoverStackTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtons()
        setConstraint()
        
    }
    
    
    //MARK: - Methods
    func setUpButtons() {
        loadView()
        
        let buttons: [UIButton] = [roverPostcardBtn, planetaryARBtn, eyeInTheSkyBtn]
        
        for button in buttons {
            button.imageView?.topAlignmentAndAspectFit(to: button)
        }
    
    }
    
    func setConstraint()  {
        print(hasTopNotch)
        if !hasTopNotch {
            print("Did not have notch")
            self.marsRoverStackTopConstraint.constant = 20
        }
    }


}
