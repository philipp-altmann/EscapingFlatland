//
//  Pedestrian.swift
//  Escaping Flatlands
//
//  Created by Philipp on 21.06.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import SceneKit

class Pedestrian: SCNNode {
    
    let c = Constants()
    let fadeOut = SCNAction.fadeOut(duration: 1)
    let enter = SCNAction.move(by: SCNVector3(-Constants().scale, 0, 0), duration: 2)
    
    
    init(at: SCNVector3) {
        //
        super.init()
    }
    
    func moveTo(_ subway:Subway, within: TimeInterval, after: TimeInterval, delay: TimeInterval) {
        //Calculate Most Suitable Wagon
        var nearestTrain = subway.wagons[0]
        for train in subway.wagons{
            if train.isBetterThan(nearestTrain, for: self) { nearestTrain = train }
        }
        
        let wait = SCNAction.wait(duration: after)
        let move = SCNAction.move(to: nearestTrain.doorPosition, duration: within)
        let delay = SCNAction.wait(duration: delay)
        
        self.runAction(SCNAction.sequence([wait, move, delay, enter, fadeOut])) {
            nearestTrain.entered()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
