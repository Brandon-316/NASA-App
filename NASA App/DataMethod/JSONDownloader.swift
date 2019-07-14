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


class JSONDownloader {
    
    let apiKey = "EZpNsGsjn5W1xzU2hulHsR4Ba0U7i6QtcdnsX6ah"
    
    typealias ObjectCompletionHandler = (ObjectModel?, Error?) -> Void
    
    func downloadJSON(for object: NASATypes, rover: Rovers? = nil, latLong: (lat: Double, long: Double)? = nil, vc: UIViewController, completion:@escaping ObjectCompletionHandler) {
        
        var objectData: ObjectModel?
        
        var urlString: String = "https://api.nasa.gov/\(object.urlString)"
        
        if let rover = rover {
            let roverString: String = rover.rawValue
            urlString = "\(urlString)\(roverString)/latest_photos?api_Key=\(apiKey)"
        }
        if let latLong = latLong {
            let latitude: String = String(latLong.lat)
            let longitude: String = String(latLong.long)
            urlString = "\(urlString)?&lon=\(longitude)&lat=\(latitude)&api_key=\(apiKey)"
        }
        
        
        guard let url: URL = URL(string: urlString) else { return }
        print("urlString: \(urlString)")
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
            
            // Decode data and calculate total number of pages
            if let urlLocation = urlLocation {
                if let data = try? Data(contentsOf: urlLocation) {
                    
                    //Use below to view JSON data
//                    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
//                        print("\njsonData: \(jsonData)")
//                    } else {
//                        print("\njsonData was nil")
//                    }
                    
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
