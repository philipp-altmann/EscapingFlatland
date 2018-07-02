//
//  Wagon.swift
//  Escaping Flatlands
//
//  Created by Philipp on 21.06.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import SceneKit

class Wagon: SCNNode {
    
    let c = Constants()
    var doorPosition: SCNVector3 = SCNVector3()
    var state: Int
    var delegate: Subway
    var wagonNo: Int
    
    init(with state: Int, at i: Int, delegate: Subway) {
        self.state = state
        self.delegate = delegate
        self.wagonNo = i
        super.init()
        let subwayGeometry = (SCNScene(named: "art.scnassets/subway.scn")!).rootNode.childNode(withName: "train", recursively: false)!.geometry!
        let subwayMaterial = SCNMaterial()
        //subwayMaterial.diffuse.contents = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        subwayMaterial.diffuse.contents = UIColor.lightGray
        subwayGeometry.materials = [subwayMaterial]
        self.geometry = subwayGeometry
        self.runAction(SCNAction.rotateBy(x: -.pi / 2, y: .pi/2, z: 0, duration: 0))
        self.scale = SCNVector3(c.scale,c.scale,c.scale)
        self.position = SCNVector3(0, 0, -(CGFloat(i) * c.size.l/3))
        //TODO get from real size / bounding Box
        self.doorPosition = SCNVector3(c.doorDistance, 0, c.size.l/3+c.size.l/6)// SCNVector3(
        print(self.boundingBox.min)
    }
    
    func isBetterThan(_ train: Wagon, for pedestrian: Pedestrian) -> Bool {
        return pedestrian.position.distance(to: self.doorPosition) < pedestrian.position.distance(to: train.doorPosition) || self.state < train.state
    }
    
    func entered() {
        self.delegate.entered(at: wagonNo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
