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




//Display message if no photos exist
extension UICollectionView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        self.backgroundView = emptyView
    }
    func restore() {
        self.backgroundView = nil
    }
}
