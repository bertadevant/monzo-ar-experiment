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
    private let dataFactory = DataFactory()
    private let fileName = "Response"
    private var planes = [UUID: VirtualPlane]()
    private var responseData: ResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupViews()
        setupLayout()
        
        responseData = dataFactory.parseJSON(fileName: fileName)
        createChart(from: responseData!)
    }
    
    private func setupHierarchy() {
        view.addSubview(sceneView)
    }
    
    private func setupViews() {
        let scene = SCNScene()
        
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = []
    }
    
    private func convertAmount(_ amount: Double) -> Double {
        var newAmount = amount
        if newAmount < 0 {
            newAmount = newAmount * -1
        }
        
        return newAmount/100
    }
    
    private func createChart(from data: ResponseData) {
        var xPosition: Float = 0
        data.transactions.forEach { transaction in
            let amountInPounds = convertAmount(transaction.amount)
            let text = String("\(transaction.description)\n £\(amountInPounds)")
            let textScene = createTextScene(text)
            let textNode = createTextNode(with: textScene, xPosition: xPosition)
//            let textCenter = getTextCenter(from: textScene)
            
            sceneView.scene.rootNode.addChildNode(textNode)
            
            let bar = SCNBox(width: 0.15, height: 0.0, length: 0.15, chamferRadius: 0)
            let barNode = createBarNode(with: bar, barXPosition: xPosition)
            
            sceneView.scene.rootNode.addChildNode(barNode)
            
            moveNodesUP(textCenter: xPosition,
                        textNode: textNode,
                        bar: bar,
                        barHeight: CGFloat(amountInPounds),
                        barNode: barNode)
            xPosition += 0.5
        }
    }
    
    private func createTextScene(_ text: String) -> SCNText {
        let textScene = SCNText(string: text, extrusionDepth: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        textScene.materials = [material]
        
        return textScene
    }
    
    private func createTextNode(with textScene: SCNText, xPosition: Float) -> SCNNode {
        let textNode = SCNNode(geometry: textScene)
        //let centerX = getTextCenter(from: textScene)
        let textVector = SCNVector3(x: xPosition, y: -1.0, z: -2.5)
        let xVectorScale: Float = 0.01
        
        textNode.position = textVector
        textNode.scale = SCNVector3(x: xVectorScale, y: 0.01, z: 0.01)
        
        return textNode
    }
    
    private func getTextCenter(from textNode: SCNText) -> Float {
        let (minVec, maxVec) = textNode.boundingBox
        let xVectorScale: Float = 0.01
        
        return Float(minVec.x - maxVec.x)/2.0 * xVectorScale
    }
    
    func createBarNode(with bar: SCNBox, barXPosition: Float) -> SCNNode {
        let barNode = SCNNode(geometry: bar)
        bar.firstMaterial?.diffuse.contents = UIColor.green
        barNode.position = SCNVector3(x: barXPosition, y: -1.0, z: -2.5)
        
        
        return barNode
    }
    
    func moveNodesUP(textCenter: Float,
                     textNode: SCNNode,
                     bar: SCNBox,
                     barHeight: CGFloat,
                     barNode: SCNNode) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10.0
        bar.height = barHeight
        textNode.position = SCNVector3(x: textCenter,
                                       y: Float(-1.0 + barHeight),
                                       z: -2.5)
        barNode.pivot = SCNMatrix4MakeTranslation(0, Float(-(bar.height/2)), 0)
        SCNTransaction.commit()
    }

//    func addCoin() {
//        let coin = SCNCylinder(radius: 0.1, height: 0.002)
//        let coinNode = SCNNode(geometry: coin)
//        let coinMaterial = SCNMaterial()
//
//        coinMaterial.diffuse.contents = UIColor.yellow
//        coin.materials = [coinMaterial]
//        coinNode.position = SCNVector3(0, 1, -3.5)
//
//        coinNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        coinNode.physicsBody!.isAffectedByGravity = true
//        coinNode.physicsBody!.friction = 0
//
//        sceneView.scene.rootNode.addChildNode(coinNode)
//    }
//
//    func addNote() {
//        let note = SCNBox(width: 0.04, height: 0.0001, length: 0.1, chamferRadius: 0)
//        let noteNode = SCNNode()
//        let coinMaterial = SCNMaterial()
//
//        coinMaterial.diffuse.contents = UIColor.green
//
//        noteNode.geometry = note
//        noteNode.position = SCNVector3(0, 0, -0.3)
//
//        sceneView.scene.rootNode.addChildNode(noteNode)
//    }
    
    private func setupLayout() {
        sceneView.pinToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension MainViewController: ARSCNViewDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // create a 3d plane from the anchor
//        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
//            let plane = VirtualPlane(anchor: arPlaneAnchor)
//            self.planes[arPlaneAnchor.identifier] = plane
//            node.addChildNode(plane)
//        }
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = planes[arPlaneAnchor.identifier] {
//            plane.updateWithNewAnchor(arPlaneAnchor)
//        }
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier) {
//            planes.remove(at: index)
//        }
//    }
}
