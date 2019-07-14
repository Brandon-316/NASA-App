//
//  CreatePostcard.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/12/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class CreatePostcardVC: UIViewController {
    
    //MARK: - Properties/Outlets
    //Properties
    var image: UIImage?
    var originY: CGFloat = 0
    
    
    //Outlets
    @IBOutlet weak var roverImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    //MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roverImageView.image = image
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePostcardVC.keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePostcardVC.keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePostcardVC.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        originY = view.frame.origin.y
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = self.originY - keyboardRect.height
        } else {
            view.frame.origin.y = self.originY
        }
        
    }
    
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 80)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func composeMail() {
        
        guard MFMailComposeViewController.canSendMail() else {
            self.generalAlert(title: "", message: "")
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        mailComposeVC.addAttachmentData(self.roverImageView.image!.jpegData(compressionQuality: 1.0)!, mimeType: "image/jpeg", fileName:  "MarsPostcard.jpeg")
        mailComposeVC.setSubject("A Postcard from Mars")
        mailComposeVC.setMessageBody("<html><body><p>This is your message</p></body></html>", isHTML: true)
        
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    
    //MARK: - Actions
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addText(_ sender: Any) {
        if textField.text != "" {
            if let image = self.image{
                guard let text = textField.text else { return }
                let newImage = textToImage(drawText: text, inImage: image, atPoint: CGPoint(x: 20, y: 20))
                self.roverImageView.image = newImage
            }
        }
    }
    
    @IBAction func email(_ sender: Any) {
        composeMail()
    }
    
}


extension CreatePostcardVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error {
            self.generalAlert(title: "Error", message: "Please check your connection and try again.\n\nError: \(error.localizedDescription)")
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            case .saved:
                print("saved")
            case .sent:
                print("sent")
        }
        
        
        controller.dismiss(animated: true)
    }
}
