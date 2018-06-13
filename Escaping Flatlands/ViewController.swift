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

class ViewController: UIViewController, ARSCNViewDelegate, BluetoothSerialDelegate {
    
    //AR Outlets
    var scene = SCNScene()
    @IBOutlet weak var sceneView: ARSCNView!
    
    //Scene Trigger Outlets
    @IBOutlet weak var scene1: UIButton!
    
    //Bluetooth Outlets
    @IBOutlet weak var bluetoothLabel: UILabel!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    //Scene Components
    var pedestrians: [SCNNode] = []
    var subway: SCNNode = SCNNode()
    
    //Set Size for Station floor
    let size:(w:CGFloat, h:CGFloat, l:CGFloat) = (0.3, 0.025, 0.75)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup AR
        setupAR()
        
        //Setup BT
        //setupBluetooth()

    }
    
    func setupAR() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        setupBase()
        sceneView.scene = scene
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
        pedestrian.scale = SCNVector3(0.1,0.1,0.1)
        pedestrian.position = position
        //pedestrian.isHidden = true
        pedestrians.append(pedestrian)
        pedestrian.runAction(SCNAction.fadeOut(duration: 0))
        scene.rootNode.addChildNode(pedestrian)
        pedestrian.runAction(SCNAction.fadeIn(duration: 1))
    }
    
    func addSubway() {
        let subwayGeometry = (SCNScene(named: "art.scnassets/subway.scn")!).rootNode.childNode(withName: "train", recursively: false)!.geometry!
        let subwayMaterial = SCNMaterial()
        subwayMaterial.diffuse.contents = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        subwayGeometry.materials = [subwayMaterial]
        subway = SCNNode(geometry: subwayGeometry)
        subway.runAction(SCNAction.rotateBy(x: -.pi / 2, y: .pi/2, z: 0, duration: 0))
        subway.scale = SCNVector3(0.1,0.1,0.1)
        subway.position = SCNVector3(-size.w - 0.005, 0, 5)
        scene.rootNode.addChildNode(subway)
    }
    
    
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    @IBAction func reloadAR(_ sender: Any) {
        let configuration = ARWorldTrackingConfiguration()
        //configuration.worldAlignment = .gravity
        self.sceneView.session.run(configuration, options: [ARSession.RunOptions.removeExistingAnchors, ARSession.RunOptions.resetTracking])
    }
    
    @IBAction func scene3(_ sender: Any) {
        print("Button Pressed")
        //serial.sendMessageToDevice("4");
        let action = SCNAction.rotateBy(x: 0, y: 0, z: .pi / 2, duration: 2)
        subway.runAction(action)
    }
    
    @IBAction func scene2(_ sender: Any) {
        print("Button Pressed")
        //serial.sendMessageToDevice("3");
        
        let action = SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 2)
        subway.runAction(action)
    }
    
    @IBAction func scene1(_ sender: Any) {
        print("Button Pressed")
        scene1.isEnabled = false
        
        addSubway()

        //subway.runAction(SCNAction.move(to: SCNVector3(-size.w - 0.005, 0, 5), duration: 0))
        let moveInSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 5)
        let fadeInSubway = SCNAction.sequence([SCNAction.wait(duration: 2), SCNAction.fadeIn(duration: 3)])
        let showSubway = moveInSubway//SCNAction.group([fadeInSubway, moveInSubway])
        
        let waitSubway = SCNAction.wait(duration: 10)
        
        let moveOutSubway = SCNAction.moveBy(x: 0, y: 0, z: -5, duration: 5)
        let fadeOutSubway = SCNAction.sequence([SCNAction.wait(duration: 2),SCNAction.fadeOut(duration: 1)])
        let hideSubway = SCNAction.group([moveOutSubway, fadeOutSubway])
        
        let resetSubway = SCNAction.moveBy(x: 0, y: 0, z: 10, duration: 1)
        let subwayChain = SCNAction.sequence([showSubway, waitSubway, hideSubway])

        subway.runAction(subwayChain) {
            DispatchQueue.main.async {
                self.scene1.isEnabled = true
            }
            self.pedestrians = []
        }
        
        
        let groupCenterX = -size.w/3
        let groupCenterZ = -size.l/5
        addPedestrian(at: SCNVector3(groupCenterX+0.02,0,groupCenterZ+0.01))
        addPedestrian(at: SCNVector3(groupCenterX-0.02,0,groupCenterZ+0.03))
        addPedestrian(at: SCNVector3(groupCenterX-0.04,0,groupCenterZ-0.04))
        addPedestrian(at: SCNVector3(groupCenterX+0.03,0,groupCenterZ-0.05))
        addPedestrian(at: SCNVector3(groupCenterX-0.01,0,groupCenterZ-0.07))
        
        
        let frontDoorZ = -size.l/3
        let backDoorZ = -size.l/3*2
        let doorDistanceX = -size.w + 0.05
        
        let wait2 = SCNAction.wait(duration: 2)
        let wait1 = SCNAction.wait(duration: 1)
        let fadeOut = SCNAction.fadeOut(duration: 1)
        let moveToFrontDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, frontDoorZ), duration: 6)
        let moveToBackDoor = SCNAction.move(to: SCNVector3(doorDistanceX, 0, backDoorZ), duration: 8)
        let moveInDoor = SCNAction.move(by: SCNVector3(-0.1, 0, 0), duration: 2)
        pedestrians[0].runAction(SCNAction.sequence([moveToFrontDoor, wait1, moveInDoor, fadeOut]))
        pedestrians[1].runAction(SCNAction.sequence([wait2, moveToFrontDoor, wait2, moveInDoor, fadeOut]))
        pedestrians[2].runAction(SCNAction.sequence([moveToBackDoor,wait1, moveInDoor, fadeOut]))
        pedestrians[3].runAction(SCNAction.sequence([wait1 ,moveToBackDoor, wait2, moveInDoor, fadeOut]))
        pedestrians[4].runAction(SCNAction.sequence([wait2, wait2, wait2, moveToFrontDoor, moveInDoor, fadeOut]))
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

    
    //Unused
    
    
    
    @IBAction func bluetoothInteraction(_ sender: Any) {
        if serial.isReady{
            //Disconnect
        } else {
            self.performSegue(withIdentifier: "showBluetoothList", sender: self)
        }
        
    }
    
    
    
    
    
    @objc func reloadView() {
        serial.delegate = self
        if serial.isReady {
            bluetoothLabel.text = "Connected to \(serial.connectedPeripheral!.name)"
            bluetoothButton.setTitle("Disconnect", for: .normal)
            bluetoothButton.tintColor = .red
        } else if serial.centralManager.state == .poweredOn {
            bluetoothLabel.text = "Not Connected"
            bluetoothButton.setTitle("Connect", for: .normal)
            bluetoothButton.tintColor = .white
        } else {
            print("Unhandled Case ")
        }
    }
    
    func serialDidReceiveString(_ message: String) {
        // add the received text to the textView, optionally with a line break at the end
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            bluetoothLabel.text = "Please turn on your devices Bluetooth!"
        }
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        //TODO blend blur view
        bluetoothLabel.text = "Disconnected"
        bluetoothButton.setTitle("Connect", for: .normal)
        bluetoothButton.tintColor = .white
    }
    
    func setupBluetooth() {
        serial = BluetoothSerial(delegate: self)
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }
    
    
}
