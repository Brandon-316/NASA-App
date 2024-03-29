//
//  NASA_AppTests.swift
//  NASA AppTests
//
//  Created by Brandon Mahoney on 7/10/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
@testable import NASA_App

class NASA_AppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    //MARK: - Test ImageService
    func testDownloadRoverImage() {
        let expectation = XCTestExpectation(description: "Image returned")
        guard let urlString = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02463/opgs/edr/fcam/FLB_616152295EDR_F0761786FHAZ00302M_.JPG") else {  return }
        var image: UIImage?
        
        ImageService.getImage(withURL: urlString) { downloadedImage in
            image = downloadedImage
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(image)
    }
    
    
    //MARK: - Test Downloading Rover Data
    func testDownloadRoverData() {
        let vc = MarsRoverVC()
        let expectation = XCTestExpectation(description: "Rover data returned")
        var roverImage: RoverImage?
        
        guard let url = vc.createRoverURL(rover: .curiosity) else { return }
        
        JSONDownloader().downloadJSON(for: .marsRover, at: url, vc: vc) { data, error in
            let roverData = data as? RoverData
            let firstObject = roverData?.latestPhotos.first
            roverImage = firstObject
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(roverImage)
    }

    
    //MARK: - Test Downloading Earth Location Data
    func testDownloadEarthLocationData() {
        let vc = EyeInTheSkyVC()
        let expectation = XCTestExpectation(description: "Location data returned")
        var locationData: EarthImage?
        let latLong = (lat: 30.274722, long: -97.740556)
        let coordinate2D = CLLocationCoordinate2D(latitude: latLong.lat, longitude: latLong.long)
        
        guard let url = vc.createEarthImageURL(with: coordinate2D) else { return }
        
        JSONDownloader().downloadJSON(for: .eyeInTheSky, at: url, vc: vc) { (data, error) in
            locationData = data as? EarthImage
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(locationData)
    }
    
    
    //MARK: - Test Location Search
    func testSearchLocations() {
        let latLong = (lat: 30.274722, long: -97.740556)
        let location = CLLocationCoordinate2D(latitude: latLong.lat, longitude: latLong.long)
        var searchResponse: MKLocalSearch.Response?
        let expectation = XCTestExpectation(description: "Locations returned")
        
        SearchLocations.handleSearch(searchString: "tacos", centerCoordinate: location) { (response, error) in
            searchResponse = response
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(searchResponse)
    }

}
