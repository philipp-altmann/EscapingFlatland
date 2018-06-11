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

class ViewController: UIViewController, ARSCNViewDelegate, BluetoothSerialDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var bluetoothLabel: UILabel!
    @IBOutlet weak var bluetoothButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup AR
        setupAR()
        
        //Setup BT
        setupBluetooth()
    }
    
    func setupAR() {
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func setupBluetooth() {
        serial = BluetoothSerial(delegate: self)
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
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
    }
    
    @IBAction func scene3(_ sender: Any) {
        print("Button Pressed")
        serial.sendMessageToDevice("4");
    }
    
    @IBAction func scene2(_ sender: Any) {
        print("Button Pressed")
        serial.sendMessageToDevice("3");
    }
    
    @IBAction func scene1(_ sender: Any) {
        print("Button Pressed")
        serial.sendMessageToDevice("2");
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
}
