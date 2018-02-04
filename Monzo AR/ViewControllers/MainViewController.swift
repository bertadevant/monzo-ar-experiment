//
//  ViewController.swift
//  Monzo AR
//
//  Created by Niamh Power on 29/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController {
    
    private let sceneView = ARSCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupViews()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(sceneView)
    }
    
    private func setupViews() {
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = []
        sceneView.antialiasingMode = .multisampling4X
        
        addCoin()
        addNote()
    }
    
    func addCoin() {
        let coin = SCNCylinder(radius: 0.01, height: 0.001)
        let coinNode = SCNNode()
        let coinMaterial = SCNMaterial()
        let collisionCapsuleRadius = CGFloat(0.4 - 0.4) * 0.4
        let collisionCapsuleHeight = CGFloat(0.4 - 0.4)
        
        coinMaterial.diffuse.contents = UIColor.yellow
        
        coinNode.geometry = coin
        coinNode.position = SCNVector3(0, 0, 10)
        
        coinNode.physicsBody = SCNPhysicsBody(type: .dynamic,
                                              shape: SCNPhysicsShape(geometry: SCNCapsule(capRadius: collisionCapsuleRadius,
                                                                                          height: collisionCapsuleHeight),
                                                                     options:nil))
        coinNode.physicsBody!.isAffectedByGravity = true
        coinNode.physicsBody!.friction = 0
        
        sceneView.scene.rootNode.addChildNode(coinNode)
    }
    
    func addNote() {
        let note = SCNBox(width: 0.04, height: 0.0001, length: 0.1, chamferRadius: 0)
        let noteNode = SCNNode()
        let coinMaterial = SCNMaterial()
        
        coinMaterial.diffuse.contents = UIColor.green
        
        noteNode.geometry = note
        noteNode.position = SCNVector3(0, 0, 10)
        
        sceneView.scene.rootNode.addChildNode(noteNode)
    }
    
    private func setupLayout() {
        sceneView.pinToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension MainViewController: ARSCNViewDelegate {
    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//    }
}

