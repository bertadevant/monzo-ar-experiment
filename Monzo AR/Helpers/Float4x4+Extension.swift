//
//  Float4x4+Extension.swift
//  Monzo AR
//
//  Created by Wayne Rumble on 04/02/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation
import SceneKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
