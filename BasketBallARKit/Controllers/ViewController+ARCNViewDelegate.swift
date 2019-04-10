//
//  ViewController+ARCNViewDelegate.swift
//  BasketBallARKit
//
//  Created by Артем on 07/04/2019.
//  Copyright © 2019 Gukov.space. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        node.addChildNode(createWall(anchor: anchor))
    }
}
