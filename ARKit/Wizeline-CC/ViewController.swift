//
//  ViewController.swift
//  Wizeline-CC
//
//  Created by Hugo Peregrina Sosa on 7/25/17.
//  Copyright © 2017 wizeline. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var modelNode: SCNNode!
    var nodeToMove: SCNNode!
    var scene: SCNScene!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        scene = SCNScene(named: "art.scnassets/dragon/main.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    func loadModel() {
        let modelScene = SCNScene(named:
            "art.scnassets/dragon/dragon.scn")!
       // sceneView.scene = scene
        modelNode = modelScene.rootNode.childNode(withName: "dragon", recursively: true)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch touches.count {
        case 1:
            guard let touch = touches.first else { return }
            if checkForObjectHit(touch: touch) {
                print("move touched model")
                if timer != nil, timer.isValid{
                    timer.invalidate()
                }
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateNodePosition), userInfo: nil, repeats: true)
            } else {
                guard let position = generateHitPosition(touch: touch) else { return }
                cloneModel(position: position)
            }
        default:
            return
        }
    }
    
    func generateHitPosition(touch: UITouch) -> SCNVector3? {
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        
        guard let hitFeature = results.last else { return nil }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        return hitPosition
    }
    
    func cloneModel(position: SCNVector3) {
        print("clone model")
        //Clone and insert a new model with hit position
        let newModel = modelNode.clone()
        newModel.position = position
        sceneView.scene.rootNode.addChildNode(newModel)
    }
    
    func checkForObjectHit(touch: UITouch) -> Bool{
        let results = sceneView.hitTest(touch.location(in: sceneView), options: nil)
        guard let hitObject = results.first else { return false }
        let node = hitObject.node
        if node.name == "dragon" {
            nodeToMove = node
            return true
        }
        return false
    }
   
    @objc func updateNodePosition() {
        guard let node = nodeToMove else { return }
        node.eulerAngles.y += 0.25
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
