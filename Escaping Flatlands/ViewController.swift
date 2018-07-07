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
    
    
    
    
//    @IBAction func PopUp(_ sender: Any) {
//        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
//
//        // add an action (button)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
    
    
    //Scene Components
    var pedestrians: [SCNNode] = []
    var subway: Subway?
    
    //Set c.size for Station floor
//    let c.size:(w:CGFloat, h:CGFloat, l:CGFloat) = (0.11, 0.01, 0.568)//(0.3, 0.025, 0.75)
//    let scale:CGFloat = 0.025//0.1
    let c = Constants()
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            
            let alert = UIAlertController(title: "Please connect to the bluetooth device", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    
    
    //Helper Function Setting Subway Station Floor
    func setupBase() {
        let floorGeometry = SCNBox(width: c.size.w, height: c.size.h, length: c.size.l, chamferRadius: 0)
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.4)
        floorGeometry.materials = [floorMaterial]
        let floor = SCNNode(geometry: floorGeometry)
        floor.position = SCNVector3(-c.size.w/2,-c.size.h/2,-c.size.l/2)
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
        pedestrian.scale = SCNVector3(c.scale,c.scale,c.scale)
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
    
    func scene1Action() {
        print("Button 1 Pressed")
        print("444")
        print(serial.sig)
        //für testzwecke
        //serial.sig = "101"
        //um einfahrt zu signalisieren
        
        
        // send 444 to signal move in train and then old occupation of subway that was received
        serial.sendMessageToDevice("444")
        print("444")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            serial.sendMessageToDevice(serial.sig)
            print(serial.sig)
        })
    
        
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
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
            
        }
    
        let groupCenterX = -c.size.w/3
        let groupCenterZ = -c.size.l/5
        let pds:CGFloat = CGFloat(c.scale/10)
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ+10*pds))
        
        //mitte
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-53*pds))
    
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-150*pds))
    
    
        
        let wait2 = SCNAction.wait(duration: 2)
        let wait1 = SCNAction.wait(duration: 1)
        let fadeOut = SCNAction.fadeOut(duration: 1)
        
    
        let frontDoorZ = -c.size.l/4 * 3.35
        let middleDoorZ = -c.size.l/4 * 2
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-c.scale, 0, 0), duration: 2)
        
        
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
        
        //Buzzer wird somit zurückgesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 18, execute: {
            print("333")
            serial.sendMessageToDevice("333")
        })
        
        //Neue Belegung der wagons
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
            serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        })
        
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor1,wait1, moveInDoor, fadeOut]))
        
        
        
    }
    
    
    
    //zweite Szene: Vorne und Hinten gleich viele
    
    func scene2Action() {
        
        
        print("Button 2 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        
        // send 444 to signal move in train and then old occupation of subway that was received
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

        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
            
        }
        
        let groupCenterX = -c.size.w/3
        let groupCenterZ = -c.size.l/5
        let pds:CGFloat = CGFloat(c.scale/10)
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX+2*pds,0,groupCenterZ+15*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        
        //mitte
        
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-90*pds))
        addPedestrian(at: SCNVector3(groupCenterX-2*pds,0,groupCenterZ-110*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-230*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-210*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-190*pds))
        

        
        let frontDoorZ = -c.size.l/4 * 3.35
        let middleDoorZ = -c.size.l/4 * 2
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-c.scale, 0, 0), duration: 2)
        
        
        
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
        
        
        //Buzzer wird somit zurückgesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 18, execute: {
            print("333")
            serial.sendMessageToDevice("333")
        })
        
        //Neue Belegung der wagons
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
            serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        })
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([wait1, targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([wait1, targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1,targetDoor1, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[6].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
    }
    
    
    //dritte Szene: alle Hinten
    
    func scene3Action() {
        
        
        print("Button 3 Pressed")
        print(serial.sig)
        //serial.sig = "202"
        
        // send 444 to signal move in train and then old occupation of subway that was received
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
        
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
                
                
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
        }
        
        let groupCenterX = -c.size.w/3
        let groupCenterZ = -c.size.l/5
        let pds:CGFloat = CGFloat(c.scale/10)
        
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+40*pds))
        
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-10*pds))
        
        //mitte
        
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-50*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-70*pds))
       
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-100*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-120*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-230*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-210*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-190*pds))
        
        
        
        let middleDoorZ = -c.size.l/4 * 2
        let frontDoorZ = -c.size.l/4 * 3.35
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveInDoor = SCNAction.move(by: SCNVector3(-c.scale, 0, 0), duration: 2)
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
        
        
        //Buzzer wird somit zurückgesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 18, execute: {
            print("333")
            serial.sendMessageToDevice("333")
        })
        
        //Neue Belegung der wagons
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
            serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        })
        
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor2, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor2, moveInDoor, fadeOut]))
        pedestrians[6].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[7].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        pedestrians[8].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
         pedestrians[9].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
        
    }
    
    
    
    func scene4Action() {
        
        
        print("Button 4 Pressed")
        print(serial.sig)
        //serial.sig = "202"
    
        // send 444 to signal move in train and then old occupation of subway that was received
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
        
        subway?.runAction(subwayChain) {
            DispatchQueue.main.async {
               
                
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print("333")
                //Buzzer wird somit zurückgesetzt
                serial.sendMessageToDevice("333")
            }
            self.pedestrians = []
        }
        
        let groupCenterX = -c.size.w/3
        let groupCenterZ = -c.size.l/5
        let pds:CGFloat = CGFloat(c.scale/10)
        
        //hinten
        
        
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+50*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+30*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-10*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-40*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-60*pds))
        
        
        //mitte
         addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-80*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-100*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-120*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-130*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-150*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-180*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-190*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-210*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-220*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-240*pds))
        
        
        let middleDoorZ = -c.size.l/4 * 2
        let frontDoorZ = -c.size.l/4 * 3.35
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveInDoor = SCNAction.move(by: SCNVector3(-c.scale, 0, 0), duration: 2)
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
        
        
        
        //Buzzer wird somit zurückgesetzt
        DispatchQueue.main.asyncAfter(deadline: .now() + 18, execute: {
            print("333")
            serial.sendMessageToDevice("333")
        })
        
        //Neue Belegung der wagons
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            print(finalFirstDigit + finalSecondDigit + finalThirdDigit)
            serial.sendMessageToDevice(finalFirstDigit + finalSecondDigit + finalThirdDigit)
        })
        
        
        
        pedestrians[0].runAction(SCNAction.sequence([targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([targetDoor2,wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([targetDoor2,wait1, moveInDoor, fadeOut]))
        pedestrians[5].runAction(SCNAction.sequence([wait1 ,targetDoor2, wait2, moveInDoor, fadeOut]))
        pedestrians[6].runAction(SCNAction.sequence([wait2,targetDoor2, wait1, moveInDoor, fadeOut]))
        pedestrians[7].runAction(SCNAction.sequence([ wait2, targetDoor1, wait1, moveInDoor, fadeOut]))
         pedestrians[8].runAction(SCNAction.sequence([wait2, wait1, targetDoor1, moveInDoor, fadeOut]))
         pedestrians[9].runAction(SCNAction.sequence([wait2, wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
         pedestrians[10].runAction(SCNAction.sequence([ wait2, targetDoor1, moveInDoor, fadeOut]))
         pedestrians[11].runAction(SCNAction.sequence([wait2, wait2, targetDoor1, moveInDoor, fadeOut]))
       pedestrians[12].runAction(SCNAction.sequence([targetDoor1, wait2, moveInDoor, fadeOut]))
        pedestrians[13].runAction(SCNAction.sequence([wait1, targetDoor1, wait1, moveInDoor, fadeOut]))
        pedestrians[14].runAction(SCNAction.sequence([targetDoor1,wait2, moveInDoor, fadeOut]))
        
        
    }
    
    
//not needed
    func scene5Action() {
        
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
    
        let groupCenterX = -c.size.w/3
        let groupCenterZ = -c.size.l/5
        let pds:CGFloat = CGFloat(c.scale/10)
        
        //hinten
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ+20*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-35*pds))
        
        //mitte
        addPedestrian(at: SCNVector3(groupCenterX-4*pds,0,groupCenterZ-60*pds))
        addPedestrian(at: SCNVector3(groupCenterX+3*pds,0,groupCenterZ-80*pds))
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-90*pds))
        
        //vorne
        addPedestrian(at: SCNVector3(groupCenterX-1*pds,0,groupCenterZ-115*pds))
        
        let middleDoorZ = -c.size.l/4 * 2
        let frontDoorZ = -c.size.l/4 * 3.35
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToMiddleDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, middleDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-c.scale, 0, 0), duration: 2)
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
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
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
        
        let pds:CGFloat = CGFloat(c.scale/10)
        let frontDoorZ = -c.size.l/4 * 3.35
        let middleDoorZ = -c.size.l/4 * 2
        let backDoorZ = -c.size.l/4 * 0.64
        let doorDistanceX = -c.size.w + 5*pds
        
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                let alert = UIAlertController(title: "Please place some figures in the subway.", message: "Press the blue buzzer when you are done.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            })
            
            //button to disconnect
        } else if serial.centralManager.state == .poweredOn {
            bluetoothLabel.text = "Not Connected"
            bluetoothButton.setTitle("Connect", for: .normal)
            bluetoothButton.tintColor = .white
            bluetoothButton.setImage(UIImage(named: "bluetooth"), for: .normal)
            bluetoothButton.setImage(UIImage(named: "bluetooth-pressed"), for: .highlighted)
            bluetoothButton.setImage(UIImage(named: "bluetooth-pressed"), for: .selected)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                let alert = UIAlertController(title: "Please connect to the bluetooth device", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            })
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
        
        //show the Instruction
        
        let alert2 = UIAlertController(title: "The occupancy of the train was saved.", message: "Please choose a scene which sets up the people on the platform.", preferredStyle: UIAlertControllerStyle.alert)
        let scene1 = UIAlertAction(title: "Scene 1 - Few", style: .default, handler: { (alertAction: UIAlertAction)in self.scene1Action()   })
        let scene2 = UIAlertAction(title: "Scene 2 - Some", style: .default, handler: { (alertAction: UIAlertAction)in self.scene2Action()     })
        let scene3 = UIAlertAction(title: "Scene 3 - Many", style: .default, handler: { (alertAction: UIAlertAction)in self.scene3Action()     })
        let scene4 = UIAlertAction(title: "Scene 4 - Loaded", style: .default, handler: { (alertAction: UIAlertAction)in self.scene4Action()     })
        
        alert2.addAction(scene1)
        alert2.addAction(scene2)
        alert2.addAction(scene3)
        alert2.addAction(scene4)
        
        // show the alert
        
        self.present(alert2, animated: true, completion: nil)
        
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
