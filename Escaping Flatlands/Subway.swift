//
//  Subway.swift
//  Escaping Flatlands
//
//  Created by Philipp on 21.06.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import SceneKit

class Subway: SCNNode {
    
    let c = Constants()
    var state: [Int]
    var wagons: [Wagon]
    var delegate: SubwayDelegate
    
    init(from State: [Int], delegate: SubwayDelegate) {
        self.wagons = []
        self.state = State
        self.delegate = delegate
        super.init()
        
        
        
        
        for i in State  {
            let wagon = Wagon(with: i, at: State.index(of: i)!, delegate: self)
            wagons.append(wagon)
            self.addChildNode(wagon)
        }
        self.position = SCNVector3(Float(-c.size.w - 0.005) + c.dfo.x, c.dfo.y, 5+c.dfo.z)
        
    }
    
    /*func setup(basePosition: SCNVector3) -> <#return type#> {
        <#function body#>
    }*/
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func entered(at: Int) {
        self.state[at] += 1
        print(self.getState())
        delegate.didChange(state: state)
    }
    
    func exit(at: Int) {
        if at > self.state.count{
            //TODO throw error
            return
        }
        self.state[at] -= 1
    }
    
    func getState() -> [Int] {
        return self.state
    }
}

protocol SubwayDelegate {
    func didChange(state: [Int])
}
