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
    
    //Return type
    typealias ObjectCompletionHandler = (ObjectModel?, Error?) -> Void
    
    func downloadJSON(for object: NASATypes, rover: Rovers? = nil, latLong: (lat: Double, long: Double)? = nil, vc: UIViewController, completion:@escaping ObjectCompletionHandler) {
        
        var objectData: ObjectModel?
        
        var urlString: String = "https://api.nasa.gov/\(object.urlString)"
        
        //Create urlString dependant on type of data being requested. Mars Rover or Eye in the Sky.
        if let rover = rover {
            let roverString: String = rover.rawValue
            urlString = "\(urlString)\(roverString)/latest_photos?api_Key=\(apiKey)"
        }
        if let latLong = latLong {
            let latitude: String = String(latLong.lat)
            let longitude: String = String(latLong.long)
            urlString = "\(urlString)?&lon=\(longitude)&lat=\(latitude)&cloud_score=True&api_key=\(apiKey)"
        }
        
        //Convert to a URL
        guard let url: URL = URL(string: urlString) else { return }
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
