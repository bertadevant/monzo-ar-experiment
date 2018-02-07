//
//  ARChartGraphNode.swift
//  Monzo AR
//
//  Created by Berta Devant on 07/02/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import UIKit
import SceneKit

class ARChartGraphNode: SCNNode {

    func createChartGraph(at location: float3, with transactions: [Transaction]) {

        var xPosition: Float = 0
        transactions.forEach { transaction in
            let chartBar = ARChartBarNode()
            let position = float3(xPosition, location.y, location.z)
            chartBar.configureNode(for: transaction, in: position, colour: UIColor.getRandomMonzoColour())
            addChildNode(chartBar)
            xPosition += 0.25
        }
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

}

fileprivate extension UIColor {

    static func getRandomMonzoColour() -> UIColor {
        let colourIndex = Int(arc4random_uniform(11))
        return monzoBrandColourArray[colourIndex]
    }
}
