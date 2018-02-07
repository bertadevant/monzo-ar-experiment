//
//  ARChartBarView.swift
//  Monzo AR
//
//  Created by Berta Devant on 07/02/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import UIKit
import SceneKit

class ARChartBarNode: SCNNode {

    private var colour = UIColor.clear

    func configureNode(for transaction: Transaction, in nodePosition: float3, colour: UIColor) {
        let amountInPounds = transaction.amount.convertAmount()
        let text = String("\(transaction.description)\n £\(amountInPounds)")
        let barHeight = CGFloat(amountInPounds / 10)
        self.colour = colour
        setupChartBar(barHeight: barHeight, position: nodePosition)
        setupChartText(text: text, position: nodePosition, barHeight: barHeight)
    }

    private func setupChartBar(barHeight: CGFloat, position: float3) {
        let barBox = SCNBox(width: 0.15, height: barHeight, length: 0.15, chamferRadius: 0)
        barBox.height = barHeight

        let barNode = createBarNode(with: barBox, position: position)
//        barNode.pivot = SCNMatrix4MakeTranslation(0, Float(-(barBox.height/2)), 0)
        addChildNode(barNode)
    }

    public func setupChartText(text: String, position: float3, barHeight: CGFloat) {
        let textScene = createTextScene(text)
        let textNode = createTextNode(with: textScene, position: position)
        textNode.position = SCNVector3(x: position.x, y: position.y, z: -0.25)
        let firstRotation = SCNMatrix4MakeRotation(Float(Double.pi/2), 0, 1, 0)
        let secondRotation = SCNMatrix4MakeRotation(Float(Double.pi/2), 1, 0, 0)
        let totalRotation = SCNMatrix4Mult(firstRotation, secondRotation)
        textNode.pivot = totalRotation
//        textNode.pivot = SCNMatrix4MakeRotation(Float(Double.pi/2), 0, 0, 1)
//        textNode.position = getZForward(node: textNode)
        addChildNode(textNode)
    }

    func getZForward(node: SCNNode) -> SCNVector3 {
        return SCNVector3(node.worldTransform.m31, node.worldTransform.m32, node.worldTransform.m33)
    }

    private func createBarNode(with bar: SCNBox, position: float3) -> SCNNode {
        let barNode = SCNNode(geometry: bar)
        bar.firstMaterial?.diffuse.contents = colour
        barNode.position = SCNVector3(x: position.x, y: position.y, z: position.z)
        return barNode
    }

    private func createTextNode(with textScene: SCNText, position: float3) -> SCNNode {
        let textNode = SCNNode(geometry: textScene)
        //let centerX = getTextCenter(from: textScene)
        let textVector = SCNVector3(x: position.x, y: position.y, z: position.z)
        let vectorScale: Float = 0.0055

        textNode.position = textVector
        textNode.scale = SCNVector3(x: vectorScale, y: vectorScale, z: vectorScale)

        return textNode
    }

    private func createTextScene(_ text: String) -> SCNText {
        let textScene = SCNText(string: text, extrusionDepth: 2)
        let material = SCNMaterial()
        material.diffuse.contents = colour
        textScene.materials = [material]

        return textScene
    }

}

fileprivate extension Double {

    func convertAmount() -> Double {
        var newAmount = self
        if newAmount < 0 {
            newAmount = newAmount * -1
        }

        return newAmount/100
    }
}

