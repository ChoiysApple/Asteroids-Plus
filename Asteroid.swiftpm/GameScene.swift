//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import SpriteKit
import SwiftUI

class GameScene: SKScene {
    
    // System data
    var score: Int = 0
    var life: Int = 3
    
    // Physics Contact
    var contactQueue = [SKPhysicsContact]()
    
    // Fire
    var timeOfLastFire: CFTimeInterval = 0.0
    var timePerFire: CFTimeInterval = 1.0       // Fire Cooltime
    var systemTime: CFTimeInterval = 1.0
    var isLoaded: Bool = true
        
    override func didMove(to view: SKView) {
        
        configure()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.systemTime = currentTime
        
        processContacts(forUpdate: currentTime)
        processAsteroidOutScreen()
        
        controlFireRate(forUpdate: currentTime)
    }
    
    private func configure() {
        
        self.backgroundColor = .black
        physicsWorld.contactDelegate = self
        
        let ship = ShipNode(scale: kShipScale, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.addChild(ship)
        
        configureHUD()
        
        spawnRandomAsteroid()
        spawnRandomAsteroid()
        spawnRandomAsteroid()
        spawnRandomAsteroid()

    }
    
}

//MARK: Touch Event
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self) {
            orientShip(touchLocation: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self) {
            orientShip(touchLocation: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            fireBullet(touchLocation: point)
        }
    }
}


//MARK: Ship Action
extension GameScene {
    
    private func orientShip(touchLocation: CGPoint) {
        let ship = childNode(withName: kShipName)

        let lookAtConstraint = SKConstraint.orient(to: touchLocation, offset: SKRange(constantValue: -CGFloat.pi / 2))
        ship?.constraints = [ lookAtConstraint ]
    }
    
    private func fireBullet(touchLocation: CGPoint) {
        
        guard isLoaded else { return }
        guard let ship = childNode(withName: kShipName) as? ShipNode else { return }     // Check is there ship
    
        let departure = ship.position
        let bullet = getBulletNode(position: departure)
        self.addChild(bullet)
        
        let destination = (touchLocation - bullet.position).normalized() * CGPoint(x: 1000, y: 1000) + bullet.position
        
        bullet.run(SKAction.sequence([
            SKAction.move(to: destination, duration: 1.0),
            SKAction.removeFromParent()
        ]))
        
        isLoaded = false
        timeOfLastFire = systemTime
        ship.fillColor = kShipUnloadedColor
    }
    
    private func controlFireRate(forUpdate currentTime: CFTimeInterval) {
        
        if (currentTime - timeOfLastFire < timePerFire) {
            isLoaded = false
        } else {
            isLoaded = true
            
            if let ship = childNode(withName: kShipName) as? ShipNode {
                ship.fillColor = kShipLoadedColor
            }
            
        }
    }
}

//MARK: Collision
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    
    private func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil { return }
      
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(kAsteroidName) && nodeNames.contains(kBulletName) {
            
            let asteroidNode = (contact.bodyA.node as? AsteroidNode) ?? (contact.bodyB.node as! AsteroidNode)
            
            makeExplosion(position: asteroidNode.position)
            updateScore(addedScore: asteroidNode.size.score)
            
            splitAsteroid(asteroid: asteroidNode)
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        } else if nodeNames.contains(kShipName) && nodeNames.contains(kAsteroidName) {
            
            updateLife()
            
            let asteroidNode = (contact.bodyA.node as? AsteroidNode) ?? (contact.bodyB.node as! AsteroidNode)
            
            makeExplosion(position: asteroidNode.position)
            splitAsteroid(asteroid: asteroidNode)
            
            asteroidNode.removeFromParent()
        }
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            if let index = contactQueue.firstIndex(of: contact) { contactQueue.remove(at: index) }
      }
    }
}

//MARK: Asteroid Event
extension GameScene {
    
    private func splitAsteroid(asteroid: AsteroidNode) {
        
        guard let newSize = AsteroidSize.init(rawValue: asteroid.size.rawValue-1) else { return }
        
        let newAsteroid0 = AsteroidNode(scaleType: newSize, position: asteroid.position)
        let newAsteroid1 = AsteroidNode(scaleType: newSize, position: asteroid.position)
        self.addChild(newAsteroid0)
        self.addChild(newAsteroid1)

        let newDirectionTuple = collisionDirection(current: asteroid.movingVector)
        newAsteroid0.movingVector = newDirectionTuple.0
        newAsteroid0.run(SKAction.move(to: newDirectionTuple.0.normalized() * CGPoint(x: 1000, y: 1000) + asteroid.position, duration: TimeInterval(newSize.scale)))
        
        newAsteroid1.movingVector = newDirectionTuple.1
        newAsteroid1.run(SKAction.move(to: newDirectionTuple.1.normalized() * CGPoint(x: 1000, y: 1000) + asteroid.position, duration: TimeInterval(newSize.scale)))
    }
    
    private func collisionDirection(current: CGPoint) -> (CGPoint, CGPoint) {
        
        let type = AsteroidSplitType.init(rawValue: Int.random(in: 0...AsteroidSplitType.allCases.count-1))
        
        var result1 = CGPoint(x: -current.y, y: current.x)
        
        switch type {
        case .DiagonalDown:
            result1 = current + result1
            break
        case .Horizontal:
            break
        case .DiagonalUp:
            result1 = current - result1
        case .none:
            break
        }
        
        let result2 = result1 * CGPoint(x: -1, y: -1)
        
        return (result1, result2)
    }
    
    private func processAsteroidOutScreen() {
        
        let screenSize = self.frame.size

        enumerateChildNodes(withName: kAsteroidName) { node, _ in
            
            guard let asteroid = node as? AsteroidNode else { return }
            
            let margin: CGFloat = 10.0
            let originalPosition = asteroid.position
            
            // right
            if asteroid.position.x >= screenSize.width + asteroid.frame.width {
                asteroid.position = CGPoint(x: -asteroid.frame.width + margin, y: asteroid.position.y)
              
            // left
            } else if asteroid.position.x <= -asteroid.frame.width-margin {
                asteroid.position = CGPoint(x: screenSize.width + asteroid.frame.width - margin, y: asteroid.position.y)
            }
            
            // top
            if asteroid.position.y >= screenSize.height + asteroid.frame.height {
                asteroid.position = CGPoint(x: asteroid.position.x, y: -asteroid.frame.width + margin)
                
            // bottom
            } else if asteroid.position.y <= -asteroid.frame.height-margin {
                asteroid.position = CGPoint(x: asteroid.position.x, y: screenSize.height + asteroid.frame.height - margin)
            }

            if originalPosition != asteroid.position {
                asteroid.removeAllActions()
                asteroid.run(SKAction.move(to: asteroid.movingVector.normalized() * CGPoint(x: 2000, y: 2000) + asteroid.position, duration: kDefaultMoveDuration))
            }
        } 
    }
    
    private func spawnRandomAsteroid() {
        let target = AsteroidNode(scaleType: .Big, position: randomPoint(target: nil))
        target.position = randomSpawnPoint(target: target)
        self.addChild(target)

        let destinationVector = randomPoint(target: target)
        target.movingVector = destinationVector.normalized()
        target.run(SKAction.move(to: destinationVector * CGPoint(x: 2000, y: 2000), duration: kDefaultMoveDuration))
    }
    
    private func randomPoint(target: SKNode?) -> CGPoint {
        
        let marginX = Float(target?.frame.width ?? 0)
        let marginY = Float(target?.frame.height ?? 0)
        
        let randomX = Float.random(in: -marginX...(Float(self.frame.width) + marginX))
        let randomY = Float.random(in: -marginY...(Float(self.frame.height) + marginY))
        
        return CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
    }
    
    private func randomSpawnPoint(target: SKNode?) -> CGPoint {
        
        let retryLimit = 5
        
        let center = childNode(withName: kShipName)?.position ?? CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let xRange = (center.x - target!.frame.width*2)...(center.x + target!.frame.width*2)
        let yRange = (center.y - target!.frame.height*2)...(center.y + target!.frame.height*2)
        
        var result = CGPoint(x: self.frame.width + 100, y: self.frame.height + 100)
        
        for _ in 0...retryLimit {
            
            result = randomPoint(target: target)
            
            if !xRange.contains(result.x) && !yRange.contains(result.y) {
                return result
            }
        }
        
        return result
    }
}

//MARK: HUD
extension GameScene {
    
    private func configureHUD() {
        
        let scoreLabel = SKLabelNode(text: String(format: "%04u pt", self.score))
        scoreLabel.position = CGPoint(x: kHUDMargin + scoreLabel.frame.width/2, y: self.frame.height-kHUDMargin)
        scoreLabel.name = kScoreLabelName
        scoreLabel.fontName = kFontName
        self.addChild(scoreLabel)
        
        let lifeLabel = SKLabelNode(text: life.lifeString)
        lifeLabel.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - lifeLabel.frame.height - 10)
        lifeLabel.name = kLifeLabelName
        lifeLabel.fontName = kFontName
        self.addChild(lifeLabel)
    }

    
    private func updateScore(addedScore: Int) {
        
        self.score += addedScore
        
        if let scoreLabel = childNode(withName: kScoreLabelName) as? SKLabelNode {
            scoreLabel.text = String(format: "%04u pt", self.score)
        }

    }
    
    private func updateLife() {
        
        self.life -= 1
        
        if let lifeLabel = childNode(withName: kLifeLabelName) as? SKLabelNode {
            lifeLabel.text = String(format: life.lifeString, self.score)
        }

    }
}
