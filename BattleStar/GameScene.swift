//
//  GameScene.swift
//  BattleStar
//
//  Created by Alumne on 23/3/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    private var pilotNode : SKSpriteNode!
    private let flightAnimation = [SKTexture(imageNamed: "Fly (1)"), SKTexture(imageNamed: "Fly (2)")]
    private let shootAnimation = [SKTexture(imageNamed: "Shoot (1)"), SKTexture(imageNamed: "Shoot (2)"), SKTexture(imageNamed: "Shoot (3)"), SKTexture(imageNamed: "Shoot (4)"), SKTexture(imageNamed: "Shoot (5)")]
    
    private var flyAction: SKAction!
    private var shootAction: SKAction!
    
    private let flyActionKey = "Fly"
    private let shootActionKey = "Shoot"
    
    private var desiredPosition: CGPoint = CGPoint(x: -250, y: -100)
    
    private var lastTime: Double = 0
    
    private let motionManager = CMMotionManager()
    
    private var accelerometerOffset : CMAccelerometerData?
    
    override func didMove(to view: SKView) {
        
        let sky = SKSpriteNode(imageNamed: "Sky-1")
        sky.zPosition = -1
        addChild(sky)
        
        if let clouds = SKEmitterNode(fileNamed: "Clouds"){
            clouds.position.x = 600
            clouds.position.y = 0
            clouds.advanceSimulationTime(10)
            addChild(clouds)
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.pilotNode = SKSpriteNode(imageNamed: "Fly (1)")
        self.pilotNode?.size = CGSize(width: w * 1.5, height: w)
        
        self.flyAction = SKAction.repeatForever(SKAction.animate(with: self.flightAnimation, timePerFrame: 0.15))
        self.shootAction = SKAction.repeatForever(SKAction.animate(with: self.shootAnimation, timePerFrame: 0.05))
        self.pilotNode.run(self.flyAction, withKey: flyActionKey)
        self.pilotNode.position = CGPoint(x: -250, y: -100)
        self.addChild(pilotNode)
        
        
        if let smoke = SKEmitterNode(fileNamed: "Smoke"){
            smoke.position.x = -40
            smoke.position.y = -20
            smoke.advanceSimulationTime(10)
            self.pilotNode.addChild(smoke)
        }
        
        motionManager.startAccelerometerUpdates()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            self.desiredPosition.y = touch.location(in: self).y
            self.pilotNode.removeAction(forKey: flyActionKey)
            self.pilotNode.run(shootAction, withKey: shootActionKey)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            self.desiredPosition.y = touch.location(in: self).y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            self.desiredPosition.y = touch.location(in: self).y
            self.pilotNode.removeAction(forKey: shootActionKey)
            self.pilotNode.run(flyAction, withKey: flyActionKey)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            self.desiredPosition.y = touch.location(in: self).y
            self.pilotNode.removeAction(forKey: shootActionKey)
            self.pilotNode.run(flyAction, withKey: flyActionKey)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let accelerometerData = self.motionManager.accelerometerData {
            guard let offset = self.accelerometerOffset else {
                self.accelerometerOffset = self.motionManager.accelerometerData
                return
            }
            let changeY = CGFloat(accelerometerData.acceleration.x - offset.acceleration.x) * 30
            self.pilotNode.position.y -= changeY
            if self.pilotNode.position.y > 200 {
                self.pilotNode.position.y = 200
            }
            if self.pilotNode.position.y < -200 {
                self.pilotNode.position.y = -200
            }
        }
        
        //self.pilotNode.position.y += (self.desiredPosition.y - self.pilotNode.position.y) * (CGFloat(currentTime) - CGFloat(lastTime)) * 10
        
        //lastTime = currentTime
    }
}
