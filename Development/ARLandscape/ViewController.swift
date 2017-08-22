//
//  ViewController.swift
//  ARLandscape
//
//  Created by Clint Cabanero on 8/18/17.
//  Copyright © 2017 Clint Cabanero. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    
    var rainierNode: SCNNode!
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - ViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        guard let scene = SCNScene(named: "art.scnassets/mt_rainier.dae") else {
            return
        }
        
        // Fetch the node for Mt. Rainier in the scene
        rainierNode = scene.rootNode.childNode(withName: "Plane", recursively: true)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // For rotating/tilting the landscape
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(gestureRecognize:)))
        sceneView.addGestureRecognizer(panRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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

    // MARK: - Gesture Action
    
    @objc
    func panGesture(gestureRecognize: UIPanGestureRecognizer) {
        let translation = gestureRecognize.translation(in: gestureRecognize.view!)
        
        let x = Float(translation.x)
        let y = Float(-translation.y)
        
        let anglePan = sqrt(pow(x, 2) + pow(y, 2)) * (Float)(Double.pi)/180.0
        
        var rotationVector = SCNVector4()
        rotationVector.x = -y
        rotationVector.y = x
        rotationVector.z = 0
        rotationVector.w = anglePan
        
        rainierNode.rotation = rotationVector
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("File: \(#file), Method: \(#function), Line: \(#line)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("File: \(#file), Method: \(#function), Line: \(#line)")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("File: \(#file), Method: \(#function), Line: \(#line)")
    }
}
