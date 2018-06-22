//
//  DistanceExtention.swift
//  Escaping Flatlands
//
//  Created by Philipp on 22.06.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3{
    func distance(to: SCNVector3) -> CGFloat {
        return CGFloat((pow(self.x - to.x, 2) + pow(self.y - to.y, 2) + pow(self.z - to.z, 2)).squareRoot())
    }
}
