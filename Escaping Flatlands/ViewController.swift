//
//  ViewController.swift
//  Escaping Flatlands
//
//  Created by Philipp on 11.06.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreBluetooth
import GLKit

class ViewController: UIViewController {
    
    //AR Outlets
    var scene = SCNScene()
    @IBOutlet weak var sceneView: ARSCNView!
    
    //Scene Trigger Outlets
    @IBOutlet weak var scene1: UIButton!
    
    @IBOutlet weak var scene2: UIButton!
    @IBOutlet weak var scene3: UIButton!
    
    @IBOutlet weak var scene4: UIButton!
    @IBOutlet weak var scene5: UIButton!
    
    
    //Bluetooth Outlets
    @IBOutlet weak var bluetoothLabel: UILabel!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    //Scene Components
    var pedestrians: [SCNNode] = []
    var subway: Subway?
    
    //Set Size for Station floor
    let size:(w:CGFloat, h:CGFloat, l:CGFloat) = (0.11, 0.01, 0.568)//(0.3, 0.025, 0.75)
    let scale:CGFloat = 0.025//0.1
    
    //subway actions
    let showSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 5)
    let waitSubway = SCNAction.wait(duration: 15)
    let moveOutSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 10)
    let fadeOutSubway = SCNAction.sequence([SCNAction.wait(duration: 2),SCNAction.fadeOut(duration: 3)])
    
    //people actions
    let wait2 = SCNAction.wait(duration: 2)
    let wait1 = SCNAction.wait(duration: 1)
    let fadeOut = SCNAction.fadeOut(duration: 1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup AR
        setupAR()
        
        //Setup BT
        setupBluetooth()

    }
    
    
    
    //Helper Function Setting Subway Station Floor
    func setupBase() {
        let floorGeometry = SCNBox(width: size.w, height: size.h, length: size.l, chamferRadius: 0)
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        floorGeometry.materials = [floorMaterial]
        let floor = SCNNode(geometry: floorGeometry)
        floor.position = SCNVector3(-size.w/2,-size.h/2,-size.l/2)
        scene.rootNode.addChildNode(floor)
    }
    
    func addPedestrian(at position: SCNVector3) {
        let pedestrianScene = SCNScene(named: "art.scnassets/SubwayScene.scn")!
        let pedestrianGeometry = pedestrianScene.rootNode.childNode(withName: "pedestrian", recursively: false)!.geometry!

        let pedestrianMaterial = SCNMaterial()
        pedestrianMaterial.diffuse.contents = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        pedestrianGeometry.materials = [pedestrianMaterial]

        let pedestrian = SCNNode(geometry: pedestrianGeometry)
        pedestrian.runAction(SCNAction.rotateBy(x: -.pi / 2, y: 0, z: 0, duration: 0))
        pedestrian.scale = SCNVector3(scale,scale,scale)
        pedestrian.position = position
        
        pedestrians.append(pedestrian)
        pedestrian.runAction(SCNAction.fadeOut(duration: 0))
        scene.rootNode.addChildNode(pedestrian)
        pedestrian.runAction(SCNAction.fadeIn(duration: 1))
    }
    
    
    
    /*func addSubway() {
        let subwayGeometry = (SCNScene(named: "art.scnassets/subway.scn")!).rootNode.childNode(withName: "train", recursively: false)!.geometry!
        let subwayMaterial = SCNMaterial()
        subwayMaterial.diffuse.contents = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        subwayGeometry.materials = [subwayMaterial]
        subway = SCNNode()
        for i in 0..<3 {
            let train = SCNNode(geometry: subwayGeometry)
            train.runAction(SCNAction.rotateBy(x: -.pi / 2, y: .pi/2, z: 0, duration: 0))
            train.scale = SCNVector3(scale,scale,scale)
            let z:CGFloat = CGFloat(i) * size.l/3 //train.boundingBox.min.x
            train.position = SCNVector3(0, 0, -z)
            subway.addChildNode(train)
        }
        /*subway = SCNNode(geometry: subwayGeometry)
        subway.runAction(SCNAction.rotateBy(x: -.pi / 2, y: .pi/2, z: 0, duration: 0))
        subway.scale = SCNVector3(0.025,0.025,0.025)//SCNVector3(0.1,0.1,0.1)
        subway.position = SCNVector3(-size.w - 0.005, 0, 5)
        let xShift = subway.boundingBox.max.x
        subway.addChildNode(<#T##child: SCNNode##SCNNode#>)*/
        
        subway.position = SCNVector3(-size.w - 0.005, 0, 5)
        scene.rootNode.addChildNode(subway)
    }*/
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravity//.camera//.gravityAndHeading//.gravity //.camera

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


    @IBAction func reloadAR(_ sender: Any) {
        let configuration = ARWorldTrackingConfiguration()
        //configuration.worldAlignment = .gravity
        self.sceneView.session.run(configuration, options: [ARSession.RunOptions.removeExistingAnchors, ARSession.RunOptions.resetTracking])
    }
    
    
    //erste Szene: alle Mittig
    
    @IBAction func scene1(_ sender: Any) {
        print("Button 1 Pressed")
        print("444")
        print(serial.sig)
        //für testzwecke
        //serial.sig = "101"
        //um einfahrt zu signalisieren
        serial.sendMessageToDevice("444")
        
        
        scene1.isEnabled = false
        scene2.isEnabled = false
        scene3.isEnabled = false
        scene4.isEnabled = false
        scene5.isEnabled = false
        
        
        self.subway = Subway(from: [0,1,2], delegate: self)
        scene.rootNode.addChildNode(subway!)
        
        //subway?.runAction(SCNAction.move(to: SCNVector3(-size.w - 0.005, 0, 5), duration: 0))
        let moveInSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 5)
      //  let fadeInSubway = SCNAction.sequence([SCNAction.wait(duration: 2), SCNAction.fadeIn(duration: 3)])
        let showSubway = moveInSubway//SCNAction.group([fadeInSubway, moveInSubway])
        
        let waitSubway = SCNAction.wait(duration: 10)
        let moveOutSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 5)
        let fadeOutSubway = SCNAction.sequence([SCNAction.wait(duration: 2),SCNAction.fadeOut(duration: 1)])
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        
       // let resetSubway = SCNAction.moveBy(x: 0, y: 0, z: 10, duration: 1)
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])
        
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
                self.scene2.isEnabled = true
                self.scene3.isEnabled = true
                self.scene4.isEnabled = true
                self.scene5.isEnabled = true
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
            
        }
    
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        let pds:CGFloat = scale/10
        
        //vorne
//        addPedestrian(at: SCNVector3(groupCenterX+2*pds,0,groupCenterZ+1*pds))
//        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ+3*pds))
//        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-4*pds))
//        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-5*pds))
//        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-7*pds))
        //mitte
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-20*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-30*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-53*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-63*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-35*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-33*pds))
        //hinten
        
        let frontDoorZ = -size.l/4 * 2
        let backDoorZ = -size.l/4 * 3
        let doorDistanceX = -size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveInDoor = SCNAction.move(by: SCNVector3(-scale, 0, 0), duration: 2)
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        let wait2 = SCNAction.wait(duration: 2)
        let wait1 = SCNAction.wait(duration: 1)
        let fadeOut = SCNAction.fadeOut(duration: 1)
        
        
        chooseDoor()
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,targetDoor1, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
        
    }
    
    
    
    //zweite Szene: Vorne und Hinten gleich viele
    
    @IBAction func scene2(_ sender: Any) {
        scene1.isEnabled = false
        scene2.isEnabled = false
        scene3.isEnabled = false
        scene4.isEnabled = false
        scene5.isEnabled = false
        
        print("Button 2 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        serial.sendMessageToDevice("444")
        print("444")
        
        self.subway = Subway(from: [0,1,2], delegate: self)
        scene.rootNode.addChildNode(subway!)
        
       
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])

        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
                self.scene2.isEnabled = true
                self.scene3.isEnabled = true
                self.scene4.isEnabled = true
                self.scene5.isEnabled = true
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
            
        }
        
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        let pds:CGFloat = scale/10
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        addPedestrian(at: SCNVector3(groupCenterX+2*pds,0,groupCenterZ+30*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ+40*pds))
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-130*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-120*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-100*pds))
        

        
        let frontDoorZ = -size.l/4 * 3
        let middleDoorZ = -size.l/4 * 2
        let backDoorZ = -size.l/4 * 1
        let doorDistanceX = -size.w + 5*pds
        
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-scale, 0, 0), duration: 2)
        
        
        
       // var targetDoor2 = moveToFrontDoor
        
        let wait2 = SCNAction.wait(duration: 2)
        let wait1 = SCNAction.wait(duration: 1)
        let fadeOut = SCNAction.fadeOut(duration: 1)
        
        
        
        var firstDigit = Int(serial.sig[serial.sig.startIndex..<serial.sig.index(serial.sig.endIndex, offsetBy: -2)])
        var secondDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:1)..<serial.sig.index(serial.sig.endIndex, offsetBy: -1)])
        var thirdDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:2)..<serial.sig.endIndex])
        //default
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        
        if firstDigit!<secondDigit!{
            if firstDigit!<thirdDigit!{
                //erste Ziffer ist kleinste bzw hinten am leersten
                targetDoor1 = moveToBackDoor
                targetDoor2 = moveToBackDoor
                firstDigit = firstDigit! + 2
                print("hinten leer")
            }else if thirdDigit!<firstDigit!{
                //letzte ist kleinste
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToFrontDoor
                print("vorne leer")
                thirdDigit = thirdDigit! + 2
            }
            else{
                //erste und letzte kleiner als mitte
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToBackDoor
                print("hinten und vorne beide leer")
                firstDigit = firstDigit! + 1
                thirdDigit = thirdDigit! + 1
            }
            
        }else if (firstDigit!==secondDigit!)&&(firstDigit!<thirdDigit!){
            //vordere beide kleiner als letzte
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToBackDoor
            print("Hinten und Mitte beide leer")
            firstDigit = firstDigit!+1
            secondDigit = secondDigit!+1
        }else if (thirdDigit!==secondDigit!)&&(thirdDigit!<firstDigit!){
            //Letzte und Mitte kleiner als erste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToMiddleDoor
            print("Vorne und Mitte beide leer")
            thirdDigit = thirdDigit!+1
            secondDigit = secondDigit!+1
        }
        else if secondDigit!<thirdDigit!{
            //mittlere ist kleinste
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToMiddleDoor
            print("mitte leer")
            secondDigit = secondDigit!+2
        }else if thirdDigit!<secondDigit!{
            //lezte ist kleinste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToFrontDoor
            print("vorne leer")
            thirdDigit = thirdDigit! + 2
        }else{
            //alle sind gleichgroß
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToBackDoor
            print("alle gleich")
            firstDigit = firstDigit! + 1
            thirdDigit = thirdDigit! + 1
        }
        
        // define and send values
        var finalFirstDigit = ""
        var finalSecondDigit = ""
        var finalThirdDigit = ""
        if firstDigit!>2{
            finalFirstDigit = "2"
        }else {
            finalFirstDigit = String(firstDigit!)
        }
        if secondDigit!>2{
            finalSecondDigit = "2"
        }else {
            finalSecondDigit = String(secondDigit!)
        }
        if thirdDigit!>2{
            finalThirdDigit = "2"
        }else {
            finalThirdDigit = String(thirdDigit!)
        }
        print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([wait1, targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([wait1, targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1,targetDoor1, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
        
    }
    
    
    //dritte Szene: alle Hinten
    
    @IBAction func scene3(_ sender: Any) {
        scene1.isEnabled = false
        scene2.isEnabled = false
        scene3.isEnabled = false
        scene4.isEnabled = false
        scene5.isEnabled = false
        
        print("Button 3 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        serial.sendMessageToDevice("444")
        print("444")
    
        
        self.subway = Subway(from: [0,1,2], delegate: self)
        scene.rootNode.addChildNode(subway!)
 
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])
        
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
                self.scene2.isEnabled = true
                self.scene3.isEnabled = true
                self.scene4.isEnabled = true
                self.scene5.isEnabled = true
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
        }
        
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        let pds:CGFloat = scale/10
        
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-130*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-120*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-110*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-115*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-125*pds))
        
        let middleDoorZ = -size.l/4 * 2
        let frontDoorZ = -size.l/4 * 3
        let backDoorZ = -size.l/4 * 1
        let doorDistanceX = -size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveInDoor = SCNAction.move(by: SCNVector3(-scale, 0, 0), duration: 2)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        
        
        
        var firstDigit = Int(serial.sig[serial.sig.startIndex..<serial.sig.index(serial.sig.endIndex, offsetBy: -2)])
        var secondDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:1)..<serial.sig.index(serial.sig.endIndex, offsetBy: -1)])
        var thirdDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:2)..<serial.sig.endIndex])
        //default
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        
        if firstDigit!<secondDigit!{
            if firstDigit!<thirdDigit!{
                //erste Ziffer ist kleinste bzw hinten am leersten
                targetDoor1 = moveToBackDoor
                targetDoor2 = moveToBackDoor
                firstDigit = firstDigit! + 2
                print("hinten leer")
            }else if thirdDigit!<firstDigit!{
                //letzte ist kleinste
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToFrontDoor
                print("vorne leer")
                thirdDigit = thirdDigit! + 2
            }
            else{
                //erste und letzte kleiner als mitte
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToBackDoor
                print("hinten und vorne beide leer")
                firstDigit = firstDigit! + 1
                thirdDigit = thirdDigit! + 1
            }
            
        }else if (firstDigit!==secondDigit!)&&(firstDigit!<thirdDigit!){
            //vordere beide kleiner als letzte
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToBackDoor
            print("Hinten und Mitte beide leer")
            firstDigit = firstDigit!+1
            secondDigit = secondDigit!+1
        }else if (thirdDigit!==secondDigit!)&&(thirdDigit!<firstDigit!){
            //Letzte und Mitte kleiner als erste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToMiddleDoor
            print("Vorne und Mitte beide leer")
            thirdDigit = thirdDigit!+1
            secondDigit = secondDigit!+1
        }
        else if secondDigit!<thirdDigit!{
            //mittlere ist kleinste
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToMiddleDoor
            print("mitte leer")
            secondDigit = secondDigit!+2
        }else if thirdDigit!<secondDigit!{
            //lezte ist kleinste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToFrontDoor
            print("vorne leer")
            thirdDigit = thirdDigit! + 2
        }else{
            //alle sind gleichgroß
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToBackDoor
            print("alle gleich")
            firstDigit = firstDigit! + 1
            thirdDigit = thirdDigit! + 1
        }
        
        // define and send values
        var finalFirstDigit = ""
        var finalSecondDigit = ""
        var finalThirdDigit = ""
        if firstDigit!>2{
            finalFirstDigit = "2"
        }else {
            finalFirstDigit = String(firstDigit!)
        }
        if secondDigit!>2{
            finalSecondDigit = "2"
        }else {
            finalSecondDigit = String(secondDigit!)
        }
        if thirdDigit!>2{
            finalThirdDigit = "2"
        }else {
            finalThirdDigit = String(thirdDigit!)
        }
        print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        
        
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor2, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
    }
    
    
    
    @IBAction func scene4(_ sender: Any) {
        scene1.isEnabled = false
        scene2.isEnabled = false
        scene3.isEnabled = false
        scene4.isEnabled = false
        scene5.isEnabled = false
        
        print("Button 4 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        serial.sendMessageToDevice("444")
        print("444")
        
        
        self.subway = Subway(from: [0,1,2], delegate: self)
        scene.rootNode.addChildNode(subway!)
        
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])
        
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
                self.scene2.isEnabled = true
                self.scene3.isEnabled = true
                self.scene4.isEnabled = true
                self.scene5.isEnabled = true
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
        }
        
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        let pds:CGFloat = scale/10
        
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+25*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+15*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+22*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+27*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-120*pds))
        
        
        let middleDoorZ = -size.l/4 * 2
        let frontDoorZ = -size.l/4 * 3
        let backDoorZ = -size.l/4 * 1
        let doorDistanceX = -size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveInDoor = SCNAction.move(by: SCNVector3(-scale, 0, 0), duration: 2)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        
        var firstDigit = Int(serial.sig[serial.sig.startIndex..<serial.sig.index(serial.sig.endIndex, offsetBy: -2)])
        var secondDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:1)..<serial.sig.index(serial.sig.endIndex, offsetBy: -1)])
        var thirdDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:2)..<serial.sig.endIndex])
        //default
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        
        if firstDigit!<secondDigit!{
            if firstDigit!<thirdDigit!{
                //erste Ziffer ist kleinste bzw hinten am leersten
                targetDoor1 = moveToBackDoor
                targetDoor2 = moveToBackDoor
                firstDigit = firstDigit! + 2
                print("hinten leer")
            }else if thirdDigit!<firstDigit!{
                //letzte ist kleinste
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToFrontDoor
                print("vorne leer")
                thirdDigit = thirdDigit! + 2
            }
            else{
                //erste und letzte kleiner als mitte
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToBackDoor
                print("hinten und vorne beide leer")
                firstDigit = firstDigit! + 1
                thirdDigit = thirdDigit! + 1
            }
            
        }else if (firstDigit!==secondDigit!)&&(firstDigit!<thirdDigit!){
            //vordere beide kleiner als letzte
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToBackDoor
            print("Hinten und Mitte beide leer")
            firstDigit = firstDigit!+1
            secondDigit = secondDigit!+1
        }else if (thirdDigit!==secondDigit!)&&(thirdDigit!<firstDigit!){
            //Letzte und Mitte kleiner als erste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToMiddleDoor
            print("Vorne und Mitte beide leer")
            thirdDigit = thirdDigit!+1
            secondDigit = secondDigit!+1
        }
        else if secondDigit!<thirdDigit!{
            //mittlere ist kleinste
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToMiddleDoor
            print("mitte leer")
            secondDigit = secondDigit!+2
        }else if thirdDigit!<secondDigit!{
            //lezte ist kleinste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToFrontDoor
            print("vorne leer")
            thirdDigit = thirdDigit! + 2
        }else{
            //alle sind gleichgroß
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToBackDoor
            print("alle gleich")
            firstDigit = firstDigit! + 1
            thirdDigit = thirdDigit! + 1
        }
        
        // define and send values
        var finalFirstDigit = ""
        var finalSecondDigit = ""
        var finalThirdDigit = ""
        if firstDigit!>2{
            finalFirstDigit = "2"
        }else {
            finalFirstDigit = String(firstDigit!)
        }
        if secondDigit!>2{
            finalSecondDigit = "2"
        }else {
            finalSecondDigit = String(secondDigit!)
        }
        if thirdDigit!>2{
            finalThirdDigit = "2"
        }else {
            finalThirdDigit = String(thirdDigit!)
        }
        print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor2, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
    }
    
    

    @IBAction func scene5(_ sender: Any) {
        scene1.isEnabled = false
        scene2.isEnabled = false
        scene3.isEnabled = false
        scene4.isEnabled = false
        scene5.isEnabled = false
        
        print("Button 5 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        
        serial.sendMessageToDevice("444")
        print("444")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            serial.sendMessageToDevice(serial.sig)
            print(serial.sig)
            
        })
        
        self.subway = Subway(from: [0,1,2], delegate: self)
        scene.rootNode.addChildNode(subway!)
        
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        
        
        
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])
        
        
        
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        let pds:CGFloat = scale/10
        
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-35*pds))
        
        //mitte
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-60*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-80*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-90*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-115*pds))
        
        let middleDoorZ = -size.l/4 * 2
        let frontDoorZ = -size.l/4 * 3
        let backDoorZ = -size.l/4 * 1
        let doorDistanceX = -size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-scale, 0, 0), duration: 2)
       let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        
        
        var firstDigit = Int(serial.sig[serial.sig.startIndex..<serial.sig.index(serial.sig.endIndex, offsetBy: -2)])
        var secondDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:1)..<serial.sig.index(serial.sig.endIndex, offsetBy: -1)])
        var thirdDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:2)..<serial.sig.endIndex])
        //default
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        
        if firstDigit!<secondDigit!{
            if firstDigit!<thirdDigit!{
                //erste Ziffer ist kleinste bzw hinten am leersten
                targetDoor1 = moveToBackDoor
                targetDoor2 = moveToBackDoor
                firstDigit = firstDigit! + 2
                print("hinten leer")
            }else if thirdDigit!<firstDigit!{
                //letzte ist kleinste
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToFrontDoor
                print("vorne leer")
                thirdDigit = thirdDigit! + 2
            }
            else{
                //erste und letzte kleiner als mitte
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToBackDoor
                print("hinten und vorne beide leer")
                firstDigit = firstDigit! + 1
                thirdDigit = thirdDigit! + 1
            }
            
        }else if (firstDigit!==secondDigit!)&&(firstDigit!<thirdDigit!){
            //vordere beide kleiner als letzte
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToBackDoor
            print("Hinten und Mitte beide leer")
            firstDigit = firstDigit!+1
            secondDigit = secondDigit!+1
        }else if (thirdDigit!==secondDigit!)&&(thirdDigit!<firstDigit!){
            //Letzte und Mitte kleiner als erste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToMiddleDoor
            print("Vorne und Mitte beide leer")
            thirdDigit = thirdDigit!+1
            secondDigit = secondDigit!+1
        }
        else if secondDigit!<thirdDigit!{
            //mittlere ist kleinste
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToMiddleDoor
            print("mitte leer")
            secondDigit = secondDigit!+2
        }else if thirdDigit!<secondDigit!{
            //lezte ist kleinste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToFrontDoor
            print("vorne leer")
            thirdDigit = thirdDigit! + 2
        }else{
            //alle sind gleichgroß
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToBackDoor
            print("alle gleich")
            firstDigit = firstDigit! + 1
            thirdDigit = thirdDigit! + 1
        }
        
        // define and send values
        var finalFirstDigit = ""
        var finalSecondDigit = ""
        var finalThirdDigit = ""
        if firstDigit!>2{
            finalFirstDigit = "2"
        }else {
            finalFirstDigit = String(firstDigit!)
        }
        if secondDigit!>2{
            finalSecondDigit = "2"
        }else {
            finalSecondDigit = String(secondDigit!)
        }
        if thirdDigit!>2{
            finalThirdDigit = "2"
        }else {
            finalThirdDigit = String(thirdDigit!)
        }
        
        //serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
                self.scene2.isEnabled = true
                self.scene3.isEnabled = true
                self.scene4.isEnabled = true
                self.scene5.isEnabled = true
               
                
                
    
                
            }
            self.pedestrians = []
        }
        
        //Buzzer wird somit zurückgesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 18, execute: {
             print("333")
            serial.sendMessageToDevice("333")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
            serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        })
        

        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,targetDoor1, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
    }
    
    // choosing the doors from the nuber of people inside
    func chooseDoor(){
        
        let pds:CGFloat = scale/10
        let frontDoorZ = -size.l/4 * 3
        let middleDoorZ = -size.l/4 * 2
        let backDoorZ = -size.l/4 * 1
        let doorDistanceX = -size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        
        var firstDigit = Int(serial.sig[serial.sig.startIndex..<serial.sig.index(serial.sig.endIndex, offsetBy: -2)])
        var secondDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:1)..<serial.sig.index(serial.sig.endIndex, offsetBy: -1)])
        var thirdDigit = Int(serial.sig[serial.sig.index(serial.sig.startIndex,offsetBy:2)..<serial.sig.endIndex])
        //default
        var targetDoor1 = moveToFrontDoor
        var targetDoor2 = moveToFrontDoor
        
        
        if firstDigit!<secondDigit!{
            if firstDigit!<thirdDigit!{
                //erste Ziffer ist kleinste bzw hinten am leersten
                targetDoor1 = moveToBackDoor
                targetDoor2 = moveToBackDoor
                firstDigit = firstDigit! + 2
                print("hinten leer")
            }else if thirdDigit!<firstDigit!{
                //letzte ist kleinste
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToFrontDoor
                print("vorne leer")
                thirdDigit = thirdDigit! + 2
            }
            else{
                //erste und letzte kleiner als mitte
                targetDoor1 = moveToFrontDoor
                targetDoor2 = moveToBackDoor
                print("hinten und vorne beide leer")
                firstDigit = firstDigit! + 1
                thirdDigit = thirdDigit! + 1
            }
            
        }else if (firstDigit!==secondDigit!)&&(firstDigit!<thirdDigit!){
            //vordere beide kleiner als letzte
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToBackDoor
            print("Hinten und Mitte beide leer")
            firstDigit = firstDigit!+1
            secondDigit = secondDigit!+1
        }else if (thirdDigit!==secondDigit!)&&(thirdDigit!<firstDigit!){
            //Letzte und Mitte kleiner als erste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToMiddleDoor
            print("Vorne und Mitte beide leer")
            thirdDigit = thirdDigit!+1
            secondDigit = secondDigit!+1
        }
        else if secondDigit!<thirdDigit!{
            //mittlere ist kleinste
            targetDoor1 = moveToMiddleDoor
            targetDoor2 = moveToMiddleDoor
            print("mitte leer")
            secondDigit = secondDigit!+2
        }else if thirdDigit!<secondDigit!{
            //lezte ist kleinste
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToFrontDoor
            print("vorne leer")
            thirdDigit = thirdDigit! + 2
        }else{
            //alle sind gleichgroß
            targetDoor1 = moveToFrontDoor
            targetDoor2 = moveToBackDoor
            print("alle gleich")
            firstDigit = firstDigit! + 1
            thirdDigit = thirdDigit! + 1
        }
        
        // define and send values
        var finalFirstDigit = ""
        var finalSecondDigit = ""
        var finalThirdDigit = ""
        if firstDigit!>2{
            finalFirstDigit = "2"
        }else {
            finalFirstDigit = String(firstDigit!)
        }
        if secondDigit!>2{
            finalSecondDigit = "2"
        }else {
            finalSecondDigit = String(secondDigit!)
        }
        if thirdDigit!>2{
            finalThirdDigit = "2"
        }else {
            finalThirdDigit = String(thirdDigit!)
        }
        print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        
    }
    

    
    //Unused
    
    
    
    @IBAction func bluetoothInteraction(_ sender: Any) {
        if serial.isReady{
            //Disconnect
            serial.disconnect()
        } else {
            self.performSegue(withIdentifier: "showBluetoothList", sender: self)
        }
    }
    
    @objc func reloadView() {
        serial.delegate = self
        if serial.isReady {
            bluetoothLabel.text = "Connected to \(serial.connectedPeripheral!.name!)"
            bluetoothButton.setTitle("Disconnect", for: .normal)
            bluetoothButton.tintColor = .red
            bluetoothButton.setImage(UIImage(named: "disconnect"), for: .normal)
            bluetoothButton.setImage(UIImage(named: "disconnect-pressed"), for: .highlighted)
            bluetoothButton.setImage(UIImage(named: "disconnect-pressed"), for: .selected)
            //button to disconnect
        } else if serial.centralManager.state == .poweredOn {
            bluetoothLabel.text = "Not Connected"
            bluetoothButton.setTitle("Connect", for: .normal)
            bluetoothButton.tintColor = .white
            bluetoothButton.setImage(UIImage(named: "bluetooth"), for: .normal)
            bluetoothButton.setImage(UIImage(named: "bluetooth-pressed"), for: .highlighted)
            bluetoothButton.setImage(UIImage(named: "bluetooth-pressed"), for: .selected)
        } else {
            print("Unhandled Case ")
        }
    }
}

extension ViewController: ARSCNViewDelegate{
    
    func setupAR() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        setupBase()
        sceneView.scene = scene
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    // Override to create and configure nodes for anchors added to the view's session.
    /*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     return node
     }*/
}

extension ViewController: BluetoothSerialDelegate{
    
    func setupBluetooth() {
        serial = BluetoothSerial(delegate: self)
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }
    
    // Called when de state of the CBCentralManager changes (e.g. when bluetooth is turned on/off)
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            bluetoothLabel.text = "Please turn on your devices Bluetooth!"
        }
    }
    
    // Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        //TODO blend blur view
        bluetoothLabel.text = "Disconnected"
        bluetoothButton.setTitle("Connect", for: .normal)
        bluetoothButton.tintColor = .white
    }
    
    // Called when a message is received
    func serialDidReceiveString(_ message: String) {
        // add the received text to the textView, optionally with a line break at the end
    }
    /*
     //Not implemented:
     
     /// Called when a message is received
     func serialDidReceiveBytes(_ bytes: [UInt8])
     
     /// Called when a message is received
     func serialDidReceiveData(_ data: Data)
     
     /// Called when the RSSI of the connected peripheral is read
     func serialDidReadRSSI(_ rssi: NSNumber)
     
     /// Called when a new peripheral is discovered while scanning. Also gives the RSSI (signal strength)
     func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?)
     
     /// Called when a peripheral is connected (but not yet ready for cummunication)
     func serialDidConnect(_ peripheral: CBPeripheral)
     
     /// Called when a pending connection failed
     func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?)
     
     /// Called when a peripheral is ready for communication
     func serialIsReady(_ peripheral: CBPeripheral)
     */
}

extension ViewController: SubwayDelegate{
    func didChange(state: [Int]) {
        print("STate Changed")
    }
}
