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
        configuration.planeDetection = .horizontal

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
        if let nodeExists = sceneView.scene.rootNode.childNode(withName: "Graph", recursively: true) {
            nodeExists.removeFromParentNode()
        }

        addNodeToSessionUsingFeaturePoints(location: location)
    }

    private func addNodeToSessionUsingFeaturePoints(location: CGPoint) {

        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: [.estimatedHorizontalPlane, .featurePoint, .existingPlane])

        if let hit = hitResultsFeaturePoints.first {
            let anchorPosition = hit.worldTransform.translation
            guard let graphNode = createGraphToAddToScene(chartPosition: anchorPosition) else {
                return
            }
            sceneView.scene.rootNode.addChildNode(graphNode)
        }
    }

    private func createGraphToAddToScene(chartPosition: float3) -> SCNNode? {
        guard let transactions = self.responseData?.transactions else {
            return nil
        }
        let graph = ARChartGraphNode()
        graph.createChartGraph(at: chartPosition, with: transactions)
        graph.name = "Graph"
        let positionForCenter = chartPosition.x - (getWidthOfNode(graph) / 2) 
        graph.position = SCNVector3(positionForCenter, chartPosition.y, chartPosition.z)
        return graph
    }

    private func getWidthOfNode(_ node: SCNNode) -> Float {
        let minX = node.boundingBox.min.x
        let maxX = node.boundingBox.max.x
        return maxX - minX
    }
}

extension MainViewController: ARSCNViewDelegate {

}
