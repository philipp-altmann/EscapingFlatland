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
   // let scale:CGFloat = 0.025//0.1
    
    
    init(at: SCNVector3) {
        //
        super.init()
        let pedestrianScene = SCNScene(named: "art.scnassets/SubwayScene.scn")!
        let pedestrianGeometry = pedestrianScene.rootNode.childNode(withName: "pedestrian", recursively: false)!.geometry!
        
        let pedestrianMaterial = SCNMaterial()
        pedestrianMaterial.diffuse.contents = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        pedestrianGeometry.materials = [pedestrianMaterial]
        
        let pedestrian = SCNNode(geometry: pedestrianGeometry)
        pedestrian.runAction(SCNAction.rotateBy(x: -.pi / 2, y: 0, z: 0, duration: 0))
        pedestrian.scale = SCNVector3(0.025,0.025,0.025)
        pedestrian.position = position
        //pedestrian.isHidden = true
       
        
        
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
