//
//  JSONDownloader.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/10/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD



struct APIService {
    static let apiKey = "EZpNsGsjn5W1xzU2hulHsR4Ba0U7i6QtcdnsX6ah"
    static let nasaURL: String = "https://api.nasa.gov/"
}


class JSONDownloader {
    
    //Return type
    typealias ObjectCompletionHandler = (ObjectModel?, Error?) -> Void
    
    
    
    func downloadJSON(for object: NASATypes, at url: URL, vc: UIViewController, completion:@escaping ObjectCompletionHandler) {
        
        var objectData: ObjectModel?
        let session: URLSession = URLSession.shared
        var jsonError: Error?
        
        
        // Get data
        SVProgressHUD.show()
        let task: URLSessionDownloadTask = session.downloadTask(with: url) { urlLocation, urlResponse, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    vc.generalAlert(title: "Error", message: "There was an error downloading your data. Please check your connection and try again.\n\nError: \(error.localizedDescription)")
                }
                return
            }
            
            // Decode data
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    switch object {
                    case .marsRover:
                        do {
                            let objects = try decoder.decode(RoverData.self, from: data)
                            objectData = objects
                        } catch {
                            jsonError = error
                        }
                    case .eyeInTheSky:
                        do {
                            let object = try decoder.decode(EarthImage.self, from: data)
                            objectData = object
                        } catch {
                            jsonError = error
                        }
                        
                    }
                }
                completion(objectData, jsonError)
            }
            
        }
        task.resume()
    }
    
    
}
