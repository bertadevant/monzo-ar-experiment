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
            chartBar.configureNode(for: transaction, in: position, colour: UIColor.random())
            addChildNode(chartBar)
            xPosition += 0.25
        }
    }



}

fileprivate extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
fileprivate extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

