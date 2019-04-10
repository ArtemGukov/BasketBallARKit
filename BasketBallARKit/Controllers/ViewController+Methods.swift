//
//  ViewController+Methods.swift
//  BasketBallARKit
//
//  Created by Артем on 07/04/2019.
//  Copyright © 2019 Gukov.space. All rights reserved.
//

import ARKit

extension ViewController {
    
    func addBasketBall() {
        guard let frame = sceneView.session.currentFrame else { return }
        
        let ball = Ball()
        let geometry = SCNSphere(radius: 0.3)
        ball.geometry = geometry
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        
        let transform = frame.camera.transform
        ball.simdTransform = transform
        
        let shape = SCNPhysicsShape(node: ball, options: [SCNPhysicsShape.Option.collisionMargin : 0.01])
        let body = SCNPhysicsBody(type: .dynamic, shape: shape)
        ball.physicsBody = body
        
        let power = Float(10)
        let cameraTransform = SCNMatrix4(transform)
        var force = SCNVector3(0, 0, -power)
        force.x = -cameraTransform.m31 * 10
        force.y = -cameraTransform.m32 * 10
        force.z = -cameraTransform.m33 * 10
        
        ball.physicsBody?.applyForce(force, asImpulse: true)
        
        ball.physicsBody?.applyTorque(SCNVector4(
            transform.columns.1.x,
            transform.columns.1.y,
            transform.columns.1.z, 0.7),
            asImpulse: true)
            
            
        ball.physicsBody?.collisionBitMask = 2
        ball.physicsBody?.contactTestBitMask = 1
        ball.name = "ball"
            
        sceneView.scene.rootNode.addChildNode(ball)
        }
    
    func createWall(anchor: ARPlaneAnchor) -> SCNNode {
        let extent = anchor.extent
        let width = CGFloat(extent.x)
        let height = CGFloat(extent.z)
        
        let node = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.eulerAngles.x = -.pi / 2
        node.name = "wall"
        node.opacity = 0.25
        
        return node
    }
    
    func addHoop(result: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/hoop.scn")!
        
        guard let node = scene.rootNode.childNode(withName: "hoop", recursively: false) else { return }
        
        node.simdTransform = result.worldTransform
        node.eulerAngles.x -= .pi / 2
        
        node.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: node, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron
            ]))

        node.addChildNode(createResultScore())
        node.addChildNode(planeDetection().0)
        node.addChildNode(planeDetection().1)
        
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            if node.name == "wall" {
                node.removeFromParentNode()
            }
        }
        
        hoopAdded = true
        scoreView.isHidden = false
        scoreLabel.isHidden = false
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func planeDetection() -> (SCNNode, SCNNode) {
        
        // Detection plane One
        let detectionOne = SCNNode(geometry: SCNPlane(width: 0.4, height: 0.4))
        
        detectionOne.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        detectionOne.position = SCNVector3(0, -0.25, 0.595)
        detectionOne.eulerAngles.x = -.pi / 2
        detectionOne.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: detectionOne))
        
        detectionOne.physicsBody?.collisionBitMask = 2
        detectionOne.physicsBody?.contactTestBitMask = 1
        detectionOne.name = "detectionPlaneOne"
        detectionOne.opacity = 0
        
        // Detection plane Two
        let detectionTwo = SCNNode(geometry: SCNPlane(width: 0.4, height: 0.4))
        detectionTwo.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        detectionTwo.position = SCNVector3(0, -0.8, 0.595)
        detectionTwo.eulerAngles.x = -.pi / 2
        detectionTwo.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: detectionOne))
        
        detectionTwo.physicsBody?.collisionBitMask = 2
        detectionTwo.physicsBody?.contactTestBitMask = 1
        detectionTwo.name = "detectionPlaneTwo"
        detectionTwo.opacity = 0
        
        return (detectionOne, detectionTwo)
    }
    
    
    func createResultScore() -> SCNNode {
        let scoreGeometry = SCNText(string: String(score), extrusionDepth: 1)
        scoreGeometry.font.withSize(14)
        
        let resultScore = SCNNode(geometry: scoreGeometry)
        resultScore.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        resultScore.position = SCNVector3(0, 0.7, 0.050)
        resultScore.scale = SCNVector3(0.03, 0.03, 0.03)
        
        scoreNode = resultScore
        return resultScore
    }
    
    func ballInTheBasket() {
        score += 2
        (scoreNode.geometry as! SCNText).string = String(score)
        
        DispatchQueue.main.async {
            self.scoreLabel.text = String(self.score)
        }
    }
}
