
//
//  GameState.swift
//  TrafficResolver
//
//  Created by Vipul Mittal on 13/03/15.
//  Copyright (c) 2015 Vipul Mittal. All rights reserved.
//
import SpriteKit

class GameState {
    var cars = [Car](count: 8, repeatedValue: Car(position: CGPoint(x:0,y:0),direction:Direction.Right))
    var runOutOfPatience:(() -> ())?
    init(){
       restart()
//        cars[4] = Car(image: "right_car", position: CGPoint(x:305,y:0), direction: Direction.Down, angle: M_PI_2)
    }
    
    func initCars(image: String, x:Int, y: Int, position : Int,direction: Direction, xchange: Int, ychange: Int, angle : Double){
        cars[position] = Car(image:image,position: CGPoint(x:x,y:y),direction:direction,angle:angle)
        cars[position+1] = Car(image:image,position: CGPoint(x:CGFloat(x + xchange),y:CGFloat(y+ychange)),direction:direction,angle:angle)
    }
    func setup(scene : SKScene, runOutOfPatience:(() -> ())?){
        for car in cars{
            car.setup(scene)
            self.runOutOfPatience = runOutOfPatience
            car.runOutOfPatience = runOutOfPatience
        }
    }
    
    func move(signalState: SignalState){
        for car in cars{
            car.move(signalState)
        }
    }
   
    func detectCollosion(){
        for i in 0...(cars.count - 2) {
            for j in i+1...(cars.count - 1) {
                var a = cars[i].position
                var b = cars[j].position
                if(a.x < b.x && a.x + 40 > b.x && a.y > b.y && a.y - 40 < b.y){
                    runOutOfPatience?()
                }
                if(a.x < b.x && a.x + 40 > b.x && a.y > b.y - 40 && a.y - 40 < b.y - 40){
                    runOutOfPatience?()
                }
                if(a.x < b.x + 40 && a.x + 40 > b.x + 40 && a.y > b.y && a.y - 40 < b.y){
                    runOutOfPatience?()
                }
                if(a.x < b.x + 40 && a.x + 40 > b.x + 40 && a.y > b.y - 40 && a.y - 40 < b.y - 40){
                    runOutOfPatience?()
                }
            }
        }
    }
    func restart(){
        initCars("car_from_left", x: 50, y: -208, position: 0, direction: Direction.Right, xchange: -200, ychange: 0,angle:0)
        initCars("right_car", x: 500, y: -158, position: 2, direction: Direction.Left,xchange: 200,ychange: 0,angle:0)
        initCars("right_car", x: 305, y: 20, position: 4, direction: Direction.Down,xchange: 0,ychange: 200 ,angle:M_PI_2)
        
        initCars("car_from_left", x: 358, y: -400, position: 6, direction: Direction.Up,xchange: 0,ychange: -200 ,angle:M_PI_2)
    }
}