//
//  ViewController.swift
//  BasketBallARKit
//
//  Created by Артем on 07/04/2019.
//  Copyright © 2019 Gukov.space. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var hoopAdded = false
    var score = 0
    var scoreNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreView.layer.cornerRadius = scoreView.bounds.width / 2
        scoreLabel.text = String(score)
        scoreView.isHidden = true
        scoreLabel.isHidden = true
        // Set the view's delegate
        sceneView.delegate = self
    
        sceneView.scene.physicsWorld.contactDelegate = self

        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
