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
    private var responseData: ResponseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupViews()
        setupLayout()
        
        responseData = dataFactory.parseJSON(fileName: fileName)
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
    
    private func setupLayout() {
        sceneView.pinToSuperviewEdges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        //if you set the plane it calls the rendered as it follows the plane which would move the objects
//        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            print("there was a problem with response data or location")
            return
        }
        addNodeToSessionUsingFeaturePoints(location: location)
    }

    private func addNodeToSessionUsingFeaturePoints(location: CGPoint) {

        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: [.estimatedHorizontalPlane, .featurePoint, .existingPlane])

        if let hit = hitResultsFeaturePoints.first {
            let anchor = ARAnchor(transform: hit.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
}

extension MainViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
         if !anchor.isKind(of: ARPlaneAnchor.self) {
            guard let transactions = self.responseData?.transactions else {
                return nil
            }
            let chartPosition = anchor.transform.translation
            let graph = ARChartGraphNode()
            graph.createChartGraph(at: chartPosition, with: transactions)
            return graph
        }
        return nil
    }


}
