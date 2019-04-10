//
//  ViewController+SCNPhysicsContactDelegate.swift
//  BasketBallARKit
//
//  Created by Артем on 10/04/2019.
//  Copyright © 2019 Gukov.space. All rights reserved.
//

import ARKit

extension ViewController: SCNPhysicsContactDelegate, SCNSceneRendererDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeB.name == "ball" && contact.nodeA.name == "detectionPlaneOne" || contact.nodeB.name == "ball" && contact.nodeA.name == "detectionPlaneTwo" {
            guard let ball = contact.nodeB as? Ball else { return }
            
            if contact.nodeB.name == "ball" && contact.nodeA.name == "detectionPlaneTwo" {
                ball.contactDetectionTwo = true
            }
            
            if !ball.contactDetectionOne && contact.nodeA.name == "detectionPlaneOne" && !ball.contactDetectionOne {
                ball.contactDetectionOne = true
                if ball.contactDetectionTwo {
                    ball.isCounted = true
                }
            }
            
            else if ball.contactDetectionOne && contact.nodeA.name == "detectionPlaneTwo" {
                
                if !ball.isCounted {
                    ballInTheBasket()
                    ball.isCounted = true
                }
            }
        }
    }
}
