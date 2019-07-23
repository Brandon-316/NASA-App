//
//  PlanetaryAR.swift
//  NASA App
//
//  Created by Brandon Mahoney on 7/10/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import DropDown


class PlanetaryARVC: UIViewController, ARSCNViewDelegate {
    
    //MARK: - Properties
    var planets: [String] = []
    var currentPlanet: Planets = .earthDay {
        didSet {
            self.changePlanet()
        }
    }
    let planetDropDown: DropDown = DropDown()
    
    let baseNode = SCNNode()
    
    let sphere = SCNSphere(radius: 0.2)
    let material = SCNMaterial()
    let planetNode = SCNNode()
    
    let saturnRingNode = SCNNode()
    let ringTube = SCNTube(innerRadius: 0.30, outerRadius: 0.45, height: 0.0001)
    
    
    //MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var planetButton: UIButton!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        createPlanetsArray()
        setupPlanetDropDown()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAR()
        setUpPlanet(with: currentPlanet)
    }
    
    
    //MARK: - Methods
    //Create array used for dropdown menu
    func createPlanetsArray() {
        for planet in Planets.allCases {
            planets.append(planet.rawValue)
        }
    }
    
    func setupPlanetDropDown() {
        planetDropDown.anchorView = planetButton
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        let offset = (planetDropDown.frame.width - planetButton.frame.width) / 2
        planetDropDown.bottomOffset = CGPoint(x: offset, y: planetButton.bounds.height)
        
        
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        planetDropDown.dataSource = planets
        
        // Action triggered on selection
        planetDropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.currentPlanet = Planets(rawValue: item)!
        }
        
        planetDropDown.dismissMode = .onTap
        
        
    }
    
    
    //MARK: - Actions
    @IBAction func changePlanet(_ sender: AnyObject) {
        planetDropDown.show()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}




//MARK: - Set Up Moon
extension PlanetaryARVC {
    
    func configureAR() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        self.sceneView.session.run(configuration)
    }
    
    func setUpPlanet(with planet: Planets) {
        
        material.diffuse.contents = UIImage(named: planet.sceneName)
        
        sphere.materials = [material]
        
        planetNode.name = "Planet"
        planetNode.position = SCNVector3(0.0, -0.1, -1.0)
        planetNode.geometry = sphere
        planetNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        planetNode.physicsBody?.isAffectedByGravity = false
        planetNode.physicsBody?.mass = 100
        planetNode.physicsBody?.collisionBitMask = 0
        
        sceneView.scene.rootNode.addChildNode(planetNode)
        
        // Set up a pan gesture recognizer and add to the sceneView.
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(didPan))
        sceneView.addGestureRecognizer(pan)
    }
    
    func addSaturnsRing() {
        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = UIImage(named: "art.scnassets/SaturnsRings.png")
        
        ringTube.materials = [ringMaterial]
        
        
        saturnRingNode.name = "SaturnsRing"
        saturnRingNode.position = SCNVector3(0.0, -0.1, -1.0)
        saturnRingNode.geometry = ringTube
        saturnRingNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        saturnRingNode.physicsBody?.isAffectedByGravity = false
        saturnRingNode.physicsBody?.mass = 100
        saturnRingNode.physicsBody?.collisionBitMask = 0
        
        sceneView.scene.rootNode.addChildNode(saturnRingNode)
    }
    
    
    func changePlanet() {
        material.diffuse.contents = UIImage(named: currentPlanet.sceneName)
        
        sphere.materials = [material]
        
        if currentPlanet == .saturn {
            addSaturnsRing()
        } else if sceneView.scene.rootNode.childNodes.contains(self.saturnRingNode) {
            saturnRingNode.removeFromParentNode()
        }
        
        planetNode.geometry = sphere
    }
    
    
    //Set gesture recognizer to conrol ability to rotate planet
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        
        let tapPoint = sender.location(in: sceneView)
        guard let hit = sceneView.hitTest(tapPoint, options: nil).first else { return }
        let node = hit.node
        
        if node.name == "Planet" || node.name == "SaturnsRing" {
            let velocity = sender.velocity(in: sceneView)
            let impulseFactor = velocity.x / 10000.0

            let objects = [self.planetNode, self.saturnRingNode]
            for object in objects {
                object.physicsBody?.applyTorque(SCNVector4Make(0, 1, 0, Float(impulseFactor)), asImpulse: true)
            }
        }
    }
    
    
    
}
