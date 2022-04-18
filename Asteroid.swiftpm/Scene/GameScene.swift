//
//  GameScene.swift
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
    var wave: Int = 1
    var isGameOver: Bool = false
    var speedConstant = 1/kAsteroidSpeedConstant
    var timePerFire: CFTimeInterval = 1.0           // Fire Cooltime
    
    // Physics Contact
    var contactQueue = [SKPhysicsContact]()
    
    // Fire
    var timeOfLastFire: CFTimeInterval = 0.0
    var systemTime: CFTimeInterval = 1.0
    var isLoaded: Bool = true
        
    override func didMove(to view: SKView) {
        
        configure()
        
        startWave(wave: wave)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        self.systemTime = currentTime
        
        processContacts(forUpdate: currentTime)
        processAsteroidOutScreen()
        
        controlFireRate(forUpdate: currentTime)
        
        processGameOver()
    }
    
    func configure() {
        
        self.backgroundColor = .black
        physicsWorld.contactDelegate = self
        
        let ship = ShipNode(scale: kShipScale, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.addChild(ship)
        
        configureHUD()
    }
    
}

//MARK: Touch Event
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isGameOver {
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: .fade(withDuration: 1.0))
        }
        
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
    
    func orientShip(touchLocation: CGPoint) {
        let ship = childNode(withName: kShipName)

        let lookAtConstraint = SKConstraint.orient(to: touchLocation, offset: SKRange(constantValue: -CGFloat.pi / 2))
        ship?.constraints = [ lookAtConstraint ]
    }
    
    func fireBullet(touchLocation: CGPoint) {
        
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
    
    func controlFireRate(forUpdate currentTime: CFTimeInterval) {
        
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
    
    func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil { return }
      
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        // Asteroid Hit
        if nodeNames.contains(kAsteroidName) && nodeNames.contains(kBulletName) {
            
            let asteroidNode = (contact.bodyA.node as? AsteroidNode) ?? (contact.bodyB.node as! AsteroidNode)
            
            makeExplosion(position: asteroidNode.position)
            updateScore(addedScore: asteroidNode.size.score)
            
            splitAsteroid(asteroid: asteroidNode)
            
            if Int.random(in: 1...100) <= 10 {
                dropRandomItem(position: asteroidNode.position)
            }
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            updateAsteroidLeft()
            
        // Hit Fast Fire Item
        } else if nodeNames.contains(kGunItemName) && nodeNames.contains(kBulletName) {
                
            hitBulletItem()
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        
        // Hit Life Item
        } else if nodeNames.contains(kLifeItemName) && nodeNames.contains(kBulletName) {
                
            hitLifeItem()
        
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        // Ship Hit
        } else if nodeNames.contains(kShipName) && nodeNames.contains(kAsteroidName) {
            
            updateLife(offset: -1)
            
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

extension GameScene {
    
    //MARK: Asteroid Hit
    func splitAsteroid(asteroid: AsteroidNode) {
        
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
    
    func collisionDirection(current: CGPoint) -> (CGPoint, CGPoint) {
        
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
    
    //MARK: Asteroid Out Screen
    func processAsteroidOutScreen() {
        
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
                asteroid.run(SKAction.move(to: asteroid.movingVector.normalized() * CGPoint(x: 2000, y: 2000) + asteroid.position, duration: kDefaultMoveDuration*self.speedConstant))
            }
        } 
    }
    
    //MARK: Spawn Asteroid
    func spawnRandomAsteroid(asteroidSpeed: TimeInterval) {
        let target = AsteroidNode(scaleType: .Big, position: randomPoint(target: nil))
        target.position = randomSpawnPoint(target: target)
        self.addChild(target)

        let destinationVector = randomPoint(target: target)
        target.movingVector = destinationVector.normalized()
        target.run(SKAction.move(to: destinationVector * CGPoint(x: 2000, y: 2000), duration: speed))
    }
        
    func randomPoint(target: SKNode?) -> CGPoint {
        
        let marginX = Float(target?.frame.width ?? 0)
        let marginY = Float(target?.frame.height ?? 0)
        
        let randomX = Float.random(in: -marginX...(Float(self.frame.width) + marginX))
        let randomY = Float.random(in: -marginY...(Float(self.frame.height) + marginY))
        
        return CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
    }
    
    func randomSpawnPoint(target: SKNode?) -> CGPoint {
        
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

//MARK: Item
extension GameScene {
    
    func spawnRandomItem() {
        
        let item = Bool.random() ? getLifeItemNode(position: CGPoint(x: self.frame.midX*0.5, y: self.frame.midY)) : getBulletItemNode(position: CGPoint(x: self.frame.midX*1.5, y: self.frame.midY))
        item.position = randomSpawnPoint(target: AsteroidNode(scaleType: .Big, position: CGPoint(x: 0,y: 0)))
        self.addChild(item)
        
        item.run(SKAction.sequence([
            SKAction.move(to: randomSpawnPoint(target: item).normalized() * CGPoint(x: 2000, y: 2000), duration: kDefaultMoveDuration),
            SKAction.removeFromParent()
        ]))
    }
    
    func dropRandomItem(position: CGPoint) {
        
        let item = Bool.random() ? getLifeItemNode(position: CGPoint(x: self.frame.midX*0.5, y: self.frame.midY)) : getBulletItemNode(position: CGPoint(x: self.frame.midX*1.5, y: self.frame.midY))
        item.position = position
        self.addChild(item)
        
        item.run(SKAction.sequence([
            SKAction.move(to: randomSpawnPoint(target: item).normalized() * CGPoint(x: 2000, y: 2000), duration: kDefaultMoveDuration),
            SKAction.removeFromParent()
        ]))

    }
    
    func hitLifeItem() {
        
        updateLife(offset: +1)
        
        showToastBehind(message: "1 more Life")
    }
    
    func hitBulletItem() {
        
        if timePerFire > 0.1 {
            timePerFire -= 0.1
        }
        
        showToastBehind(message: "Fire Faster")
    }

}

//MARK: HUD
extension GameScene {
    
    func configureHUD() {
        
        let scoreLabel = SKLabelNode(text: String(format: "%04u pt", self.score))
        scoreLabel.position = CGPoint(x: kHUDMargin + scoreLabel.frame.width/2, y: self.frame.height-kHUDMargin)
        scoreLabel.name = kScoreLabelName
        scoreLabel.fontName = kRetroFontName
        self.addChild(scoreLabel)
        
        let lifeLabel = SKLabelNode(text: life.lifeString)
        lifeLabel.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - lifeLabel.frame.height - 10)
        lifeLabel.name = kLifeLabelName
        lifeLabel.fontName = kRetroFontName
        lifeLabel.fontSize = 20
        self.addChild(lifeLabel)
        
        let asteroidLabel = SKLabelNode(text: String(format: "Asteroids Left:", self.score))
        asteroidLabel.horizontalAlignmentMode = .center
        asteroidLabel.position = CGPoint(x: self.frame.width-(kHUDMargin + asteroidLabel.frame.width/2), y: self.frame.height-kHUDMargin)
        asteroidLabel.name = kAsteroidLeftTitleName
        asteroidLabel.fontName = kRetroFontName
        asteroidLabel.fontSize = 20
        self.addChild(asteroidLabel)
        
        let asteroidNumberLabel = SKLabelNode(text: String(format: "%02u", self.score))
        asteroidLabel.horizontalAlignmentMode = .center
        asteroidNumberLabel.name = kAsteroidLeftNumberName
        asteroidNumberLabel.fontName = kRetroFontName
        asteroidNumberLabel.position = CGPoint(x: asteroidLabel.frame.midX, y: asteroidLabel.frame.minY-asteroidNumberLabel.frame.height-10)
        self.addChild(asteroidNumberLabel)
    }
    
    func removeHUD() {
        self.childNode(withName: kScoreLabelName)
        self.childNode(withName: kLifeLabelName)
        self.childNode(withName: kAsteroidLeftTitleName)
        self.childNode(withName: kAsteroidLeftNumberName)
    }

    
    func updateScore(addedScore: Int) {
        
        self.score += addedScore
        
        if let scoreLabel = childNode(withName: kScoreLabelName) as? SKLabelNode {
            scoreLabel.text = String(format: "%04u pt", self.score)
        }

    }
    
    func updateLife(offset: Int) {
        
        self.life += offset
        
        if let lifeLabel = childNode(withName: kLifeLabelName) as? SKLabelNode {
            lifeLabel.text = String(format: life.lifeString, self.score)
        }
    }
    
    func updateAsteroidLeft() {
        
        var count = 0
        enumerateChildNodes(withName: kAsteroidName) { _, _ in
            count += 1
        }
        
        if let leftLabel = childNode(withName: kAsteroidLeftNumberName) as? SKLabelNode {
            leftLabel.text = String(format: "%02u", count)
        }
        
    }
}

//MARK: Game Over Logic
extension GameScene {
    
    func processGameOver() {
        
        if life <= 0 {
            isGameOver = true
            showPopUp()
            removeHUD()
        } else if childNode(withName: kAsteroidName) == nil {
            wave += 1
            startWave(wave: wave)
            spawnRandomItem()
        }
        
    }
    
    func startWave(wave: Int) {
        
        showToastBehind(message: "Wave \(wave)")
        
        let numberOfAsteroid = wave
        speedConstant *= kAsteroidSpeedConstant
        
        for _ in 1...numberOfAsteroid {
            spawnRandomAsteroid(asteroidSpeed: kDefaultMoveDuration*speedConstant)
        }
        updateAsteroidLeft()
        
    }
    
    func showToastBehind(message: String) {
        
        let labelNode = SKLabelNode(text: message)
        labelNode.fontName = "\(kMenuFontName)-Medium"
        labelNode.fontColor = .lightGray
        labelNode.fontSize = 60
        labelNode.zPosition = -20
        self.addChild(labelNode)
        
        var start = CGPoint(x: -labelNode.frame.width, y: self.frame.midY)
        var end = CGPoint(x: self.frame.maxX+labelNode.frame.width, y: self.frame.midY)
        if Bool.random() { (start, end) = (end, start) }
        
        labelNode.position = start
        
        labelNode.run(SKAction.sequence([
            SKAction.move(to: end, duration: 5.0),
            SKAction.removeFromParent()
        ]))
    }

}
