//
//  ViewController+@IBAction.swift
//  BasketBallARKit
//
//  Created by Артем on 07/04/2019.
//  Copyright © 2019 Gukov.space. All rights reserved.
//

import UIKit

extension ViewController {
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        
        if !hoopAdded {
            let location = sender.location(in: sceneView)
            let results = sceneView.hitTest(location, types: [.existingPlaneUsingExtent])
            guard let result = results.first else { return }
            addHoop(result: result)
        
        } else {
            addBasketBall()
        }
    }
}
