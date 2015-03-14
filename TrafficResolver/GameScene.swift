//
//  GameScene.swift
//  TrafficResolver
//
//  Created by Vipul Mittal on 13/03/15.
//  Copyright (c) 2015 Vipul Mittal. All rights reserved.
//

import SpriteKit
let NumColumns = 10
let NumRows = 20
let BlockSize:CGFloat = 20.0
let TickLengthLevelOne = NSTimeInterval(50)

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    let carFromLeft = SKSpriteNode();
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    var gameState = GameState()
    let signalState = SignalState()
    var stop = false
    var leftSignal = SKSpriteNode()
    var topSignal = SKSpriteNode()
    var bottomSignal = SKSpriteNode()
    var rightSignal = SKSpriteNode()
    var tecture = SKTexture(imageNamed: "red");
    var tectureGreen = SKTexture(imageNamed: "teal");
    var winner = SKLabelNode()
    var score = 0
    var savedScore = 0
    
    override func update(currentTime: CFTimeInterval) {
        if(!stop){
            if lastTick == nil {
                return
            }
            var timePassed = lastTick!.timeIntervalSinceNow * -1000.0
            if timePassed > tickLengthMillis {
                lastTick = NSDate()
                gameState.move(signalState)
                gameState.detectCollosion()
                score++
                winner.text = "Your score \(Int(score/10))"
            }
        }
    }
    
    func carRanOutOfPatience(){
        stop = true;
        print("stoped")
        if(score/10 > savedScore){
            NSUserDefaults.standardUserDefaults().setObject(score/10, forKey:"HighestScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        var baseBar = SKSpriteNode(color: SKColor.whiteColor(),size: CGSizeMake(500, 300))
        baseBar.position = CGPoint(x: 330,y: -180)
        var winner = SKLabelNode()
        winner.fontSize = 20;
        winner.fontName = "AmericanTypewriter-Bold"
        winner.fontColor = SKColor.blackColor();
        winner.position = CGPoint(x: 0,y: 0)
        winner.text = "Your score \(Int(score/10)) \n high-score \(savedScore)"
        baseBar.addChild(winner)
        
        var restart = SKSpriteNode(color: SKColor.blackColor(),size: CGSizeMake(100, 40))
        restart.position = CGPoint(x: 0,y: -100)
        
        var winner1 = SKLabelNode()
        winner1.fontSize = 20;
        winner1.fontColor = SKColor.whiteColor();
        winner1.position = CGPoint(x: 0,y: -5)
        winner1.text = "restart"
        restart.addChild(winner1)
        
        baseBar.addChild(restart)
        self.addChild(baseBar)

    }
    
    func restart(){
        if(stop){
            self.removeAllChildren()
            gameState.restart();
            signalState.reset()
            drawEverything();
            stop = false;
            score = 0;
        }
    }
    // #3
    func nextPosition(currentPosition: CGPoint, direction: Direction) -> CGPoint {
        let x: CGFloat = currentPosition.x + 5;
        //let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPointMake(x, currentPosition.y)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        drawEverything();
    }

    func drawEverything(){
        anchorPoint = CGPoint(x: 0, y: 1.0)
        let background = SKSpriteNode(imageNamed: "grass_background")
        background.position = CGPoint(x: 0, y: 0)
        background.size = CGSizeMake(1600, 800);
        addChild(background)
        
        let verticalRoad = SKSpriteNode(imageNamed: "background")
        verticalRoad.position = CGPoint(x: 330, y: 0)
        verticalRoad.size = CGSizeMake(100, 800);
        addChild(verticalRoad)
        
        let horizontalRoad = SKSpriteNode(imageNamed: "background")
        horizontalRoad.position = CGPoint(x: 0, y: -180)
        horizontalRoad.size = CGSizeMake(1600, 100);
        addChild(horizontalRoad)
        
        var barra1 = SKShapeNode(rectOfSize: CGSizeMake(5, 255))
        barra1.fillColor = SKColor.whiteColor()
        barra1.position = CGPoint(x: 331, y: 0)
        self.addChild(barra1)
        
        var barra2 = SKShapeNode(rectOfSize: CGSizeMake(5, 300))
        barra2.fillColor = SKColor.whiteColor()
        barra2.position = CGPoint(x: 331, y: -380)
        self.addChild(barra2)
        
        var hline1 = SKShapeNode(rectOfSize: CGSizeMake(550, 5))
        hline1.fillColor = SKColor.whiteColor()
        hline1.position = CGPoint(x: 0, y: -182)
        self.addChild(hline1)
        
        var hline2 = SKShapeNode(rectOfSize: CGSizeMake(550, 5))
        hline2.fillColor = SKColor.whiteColor()
        hline2.position = CGPoint(x: 660, y: -182)
        self.addChild(hline2)
        
        let x = 50
        let y = -208
        leftSignal = SKSpriteNode(texture: tecture)
        topSignal = SKSpriteNode(texture: tecture)
        bottomSignal = SKSpriteNode(texture: tecture)
        rightSignal = SKSpriteNode(texture: tecture)
        
        addSignal(leftSignal,image: "red",x: 290,y: -208)
        addSignal(rightSignal,image: "red",x: 370,y: -158)
        addSignal(topSignal,image: "red",x: 305,y: -138)
        addSignal(bottomSignal,image: "red",x: 355,y: -218)
        
        gameState.setup(self,carRanOutOfPatience)
        
        
        var scoreObject = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore");
        
        
        if(scoreObject != nil){
            savedScore = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore")? as Int
            println(savedScore)
        }
        displayHouse("home_1", x: 90, y: -95)
        displayHouse("home_2", x: 160, y: -95)
        displayHouse("home",x: 230, y: -95)
        displayHouse("folder_home", x: 440, y: -95)
        displayHouse("house", x: 520, y: -95)
        displayHouse("home_3", x: 600, y: -95)

        displayHouse("tree", x: 40, y: -240)
        displayHouse("tree", x: 65, y: -240)
        displayHouse("tree", x: 80, y: -240)
        displayHouse("tree", x: 140, y: -240)
        displayHouse("tree", x: 200, y: -240)

        
        displayHouse("tree", x: 430, y: -240)
        displayHouse("tree", x: 440, y: -240)
        displayHouse("tree", x: 455, y: -240)
        displayHouse("tree", x: 480, y: -240)
        displayHouse("tree", x: 495, y: -240)
        displayHouse("tree", x: 530, y: -240)

        displayHouse("house_1", x: 230, y: -280)
        displayHouse("house_2", x: 420, y: -280)

        
        winner.fontSize = 20;
        winner.fontColor = SKColor.blackColor();
        winner.position = CGPoint(x: 120,y: -30)
        winner.fontName = "AmericanTypewriter-regular"

        winner.text = "Your score \(savedScore)"
        var highscore = SKLabelNode()
        highscore.fontSize = 20;
        highscore.fontColor = SKColor.blackColor();
        highscore.position = CGPoint(x: 550,y: -30)
        highscore.fontName = "AmericanTypewriter-regular"
        
        highscore.text = "high-score \(savedScore)"
        self.addChild(winner)
        self.addChild(highscore)
        startTicking()
        
    }
    
    
    func displayHouse(image : String, x: Int, y: Int){
        let horizontalRoad = SKSpriteNode(imageNamed: image)
        horizontalRoad.position = CGPoint(x: x, y: y)
        horizontalRoad.size = CGSizeMake(60, 60);
        addChild(horizontalRoad)
    }
    
    func addSignal(node:SKSpriteNode,image: String,x:Int,y:Int){
        node.position = CGPoint(x: x, y: y)
        node.size = CGSizeMake(20, 20);
        addChild(node)
    }
    
    // #4
    func startTicking() {
        lastTick = NSDate()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func signalChanged(direction:Direction){
        switch(direction){
        case .Right:
            if(signalState.right==0){
                signalState.right = 260;
                leftSignal.texture = tecture;
            }
            else{
                signalState.right = 0;
                leftSignal.texture = tectureGreen;
            }
            break
        case .Left:
            if(signalState.left==0){
                signalState.left = 400;
                rightSignal.texture = tecture;
            }
            else{
                signalState.left = 0;
                rightSignal.texture = tectureGreen;

            }
            break
        case .Down:
            if(signalState.bottom == -1){
                signalState.bottom = -100;
                topSignal.texture = tecture;
            }
            else{
                signalState.bottom = -1;
                topSignal.texture = tectureGreen;

            }
            break
        case .Up:
            if(signalState.top==0){
                signalState.top = -250;
                bottomSignal.texture = tecture;

            }
            else{
                signalState.top = 0;
                bottomSignal.texture = tectureGreen;
            }
            break
        default:
            break
        }
        return
    }
}
