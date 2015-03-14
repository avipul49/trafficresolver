//
//  GameViewController.swift
//  TrafficResolver
//
//  Created by Vipul Mittal on 13/03/15.
//  Copyright (c) 2015 Vipul Mittal. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .Fill
        // Present the scene.
        skView.presentScene(scene)
    }

  
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        var point = sender.locationOfTouch(0, inView: self.view)
        if(point.x > 280 && point.x < 300 && point.y > 200 && point.y < 220){
            scene.signalChanged(Direction.Right)
        }
        if(point.x > 360 && point.x < 380 && point.y > 150 && point.y < 170){
            scene.signalChanged(Direction.Left)
        }
        if(point.x > 295 && point.x < 320 && point.y > 135 && point.y < 150){
            scene.signalChanged(Direction.Down)
        }
        if(point.x > 345 && point.x < 365 && point.y > 210 && point.y < 230){
            scene.signalChanged(Direction.Up)
        }
        if(point.x > 280 && point.x < 380 && point.y > 260 && point.y < 305){
            scene.restart()
        }
        print(point)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
