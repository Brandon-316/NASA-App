//
//  Extensions.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/11/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


//Alert user
extension UIViewController {
    func generalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

//Used to handle top alinged aspectFill for MainVC button imageViews
extension UIImageView {
    func topAlignmentAndAspectFit(to view: UIView) {
        self.contentMode = .scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        self.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .width,
                                multiplier: self.frame.size.height / self.frame.size.width,
                                constant: 0.0)])
        view.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1.0,
                                constant: 0.0)])
        view.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .width,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .width,
                                multiplier: 1.0,
                                constant: 0.0)])
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]",
                                           options: .alignAllTop,
                                           metrics: nil,
                                           views: ["imageView": self]))
    }
}
