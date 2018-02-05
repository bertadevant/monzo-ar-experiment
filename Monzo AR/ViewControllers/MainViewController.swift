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
        
        let manager = NetworkManager()
        manager.request()
        
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
        
        // addCoin()
        // addNote()
        addGrowingSquare()
    }
    
    func addGrowingSquare() {
        let text = "Beer £10.50"
        let textScene = SCNText(string: text, extrusionDepth: 2)
        let material = SCNMaterial()
        let textNode = SCNNode(geometry: textScene)
        let (minVec, maxVec) = textNode.boundingBox
        let xVectorScale: Float = 0.01
        let centerX = Float(minVec.x - maxVec.x)/2.0 * xVectorScale
        let textVector = SCNVector3(x: centerX, y: -1.0, z: -2.5)
        
        textNode.position = textVector
        material.diffuse.contents = UIColor.green
        textScene.materials = [material]
        textNode.scale = SCNVector3(x: xVectorScale, y: 0.01, z: 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
        
        let box = SCNBox(width: 0.1, height: 0.0, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        box.firstMaterial?.diffuse.contents = UIColor.green
        boxNode.position = SCNVector3(x: 0, y: -1.0, z: -2.5)
        sceneView.scene.rootNode.addChildNode(boxNode)
        boxNode.pivot = SCNMatrix4MakeTranslation(0, Float(-(box.height/2)), 0)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10.0
        box.height = 1
        textNode.position = SCNVector3(x: centerX, y: 0.0, z: -2.5)
        boxNode.pivot = SCNMatrix4MakeTranslation(0, Float(-(box.height/2)), 0) // new height
        SCNTransaction.commit()
    }
    
    func addCoin() {
        let coin = SCNCylinder(radius: 0.01, height: 0.05)
        let coinNode = SCNNode()
        let coinMaterial = SCNMaterial()
        
        coinMaterial.diffuse.contents = UIColor.yellow
        
        coinNode.geometry = coin
        coinNode.position = SCNVector3(0, 0, -0.05)
        

        coinNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
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
        noteNode.position = SCNVector3(0, 0, -0.3)
        
        sceneView.scene.rootNode.addChildNode(noteNode)
    }
    
    private func setupLayout() {
        sceneView.pinToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
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

