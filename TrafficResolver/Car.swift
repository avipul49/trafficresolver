//
//  Car.swift
//  TrafficResolver
//
//  Created by Vipul Mittal on 13/03/15.
//  Copyright (c) 2015 Vipul Mittal. All rights reserved.
//
import SpriteKit

let topMax = 50;
let bottomMax = -800
let leftMax = -50
let rightMax = 1000

enum Direction {
    case Left
    case Right
    case Up
    case Down
}

class Car {
    var position: CGPoint!
    var direction = Direction.Right
    var carFromLeft = SKSpriteNode()
    var baseBar = SKSpriteNode()
    var bar = SKSpriteNode()
    var stoped = false
    var patience = 100.0;
    var width = 100;
    var runOutOfPatience:(() -> ())?
    var imageName = "car_from_left"
    var angle = 0.0
    var speed = 5;
    init(position: CGPoint, direction : Direction) {
        self.position = position
        self.direction = direction
    }
    
    init(image: String, position: CGPoint, direction : Direction, angle: Double) {
        self.position = position
        self.direction = direction
        self.imageName = image;
        self.angle = Double(angle);
    }
    
    func rotate(){
        carFromLeft.zRotation = CGFloat(M_PI_4);
    }
    
    func setup(scene: SKScene){
        carFromLeft = SKSpriteNode(imageNamed: imageName)
        carFromLeft.position = position
        carFromLeft.size = CGSizeMake(40,20);
        carFromLeft.zRotation = CGFloat(angle)
        scene.addChild(carFromLeft)
        
        baseBar = SKSpriteNode(color: SKColor.whiteColor(),size: CGSizeMake(40, 5))
        baseBar.position = CGPoint(x: position.x,y: position.y + 15)
        
        
        scene.addChild(baseBar)
       
        bar = SKSpriteNode(color: SKColor.greenColor(),size: CGSizeMake(40, 5))
        bar.position = CGPoint(x: position.x, y: position.y + 15)
        scene.addChild(bar)
    }

    
    func move(signalState : SignalState){
        position = getNextPosition(signalState)
        //carFromLeft.runAction(getNextAction(signalState))
        carFromLeft.position = position
        baseBar.position = CGPoint(x: position.x,y: position.y + 15)
        var result: Double = 40*Double(patience) / Double(width)
        if(result>0){
            bar.size = CGSizeMake(CGFloat(result), 5);
        }else{
            runOutOfPatience?()
        }
        bar.position = CGPoint(x: position.x, y: position.y + 15)
        
    }
    
    func getNextPosition(signalState : SignalState) -> CGPoint{
        switch(direction){
        case .Left:
            if(!stoped){
                if(Int(position.x) < leftMax){
                    return CGPoint(x:CGFloat(rightMax + 50 * Int(arc4random_uniform(3))),y:position.y)
                }
                else if(signalState.left == 0 || signalState.left < (Int(position.x) - speed) || signalState.left > (Int(position.x))){
                    return CGPoint(x:position.x - CGFloat(speed),y:position.y)
                }
                else{
                    signalState.left += 50;
                    stoped = true
                }
            }else{
                if(signalState.left == 0){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }
            break
        case .Right:
            if(!stoped){
                if(Int(position.x) > rightMax){
                    return CGPoint(x:CGFloat(-50*Int(arc4random_uniform(3))),y:position.y)
                }
                else if(signalState.right == 0 || signalState.right > Int(position.x) + speed || signalState.right < (Int(position.x))){
                    return CGPoint(x:position.x + CGFloat(speed),y:position.y)
                }
                else{
                    signalState.right -= 50;
                    stoped = true
                }
            }else{
                if(signalState.right == 0){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }
            break
        case .Up:
            if(!stoped){
                if(Int(position.y) > topMax){
                    return CGPoint(x:position.x,y:CGFloat(bottomMax + (-100*Int(arc4random_uniform(2)))))
                }
                else if(signalState.top == 0 || signalState.top > Int(position.y) + speed || signalState.top < (Int(position.y))){
                    return CGPoint(x:position.x ,y:position.y + CGFloat(speed))
                }
                else{
                    signalState.top -= 50;
                    stoped = true
                }
            }else{
                if(signalState.top == 0){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }

            break
        case .Down:
            if(!stoped){
                if(Int(position.y) < bottomMax){
                    return CGPoint(x:position.x,y:CGFloat(100*Int(arc4random_uniform(2))))
                }
                else if(signalState.bottom == -1 || signalState.bottom < Int(position.y) - speed || signalState.bottom > (Int(position.y))){
                    return CGPoint(x:position.x ,y:position.y - CGFloat(speed))
                }
                else{
                    signalState.bottom += 50;
                    stoped = true
                }
            }else{
                if(signalState.bottom == -1){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }
            break
        }
        return position;
    }
    
    func getNextAction(signalState : SignalState) -> SKAction{
        switch(direction){
        case .Left:
            if(!stoped){
                if(Int(position.x) < leftMax){
                    var negDelta = CGVectorMake(-position.x,0);
                    return SKAction.moveBy(negDelta, duration: NSTimeInterval(0))
                    //return CGPoint(x:0,y:position.y)
                }
                else if(signalState.right == 0 || signalState.right > (Int(position.x) + 5)){
                    var negDelta = CGVectorMake(5,0);
                    return SKAction.moveBy(negDelta, duration: NSTimeInterval(0))
                    //return CGPoint(x:position.x + 5,y:position.y)
                }
                else{
                    signalState.right -= 50;
                    stoped = true
                }
            }else{
                if(signalState.right == 0){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }
            break
        case .Right:
            if(!stoped){
                if(Int(position.x) > rightMax){
                    var negDelta = CGVectorMake(-position.x,0);
                    return SKAction.moveBy(negDelta, duration: NSTimeInterval(0))
                    //return CGPoint(x:0,y:position.y)
                }
                else if((signalState.right == 0 || signalState.right > Int(position.x) + 5) || signalState.right < (Int(position.x))){
                    var negDelta = CGVectorMake(5,0);
                    return SKAction.moveBy(negDelta, duration: NSTimeInterval(0))
                    //return CGPoint(x:position.x + 5,y:position.y)
                }
                else{
                    signalState.right -= 50;
                    stoped = true
                }
            }else{
                if(signalState.left == 0){
                    stoped = false;
                }else{
                    patience = patience - 0.5;
                }
            }
            break
        case .Up:
            break
        case .Down:
            break
        }
       return SKAction()

    }
}