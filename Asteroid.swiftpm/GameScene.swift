//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import SpriteKit

class GameScene: SKScene {
    
    var contactQueue = [SKPhysicsContact]()
        
    override func didMove(to view: SKView) {

        backgroundColor = .black

        physicsWorld.contactDelegate = self
        
        configureNodes()
    }
    
    override func update(_ currentTime: TimeInterval) {
        processContacts(forUpdate: currentTime)
    }
    
    private func configureNodes() {
        
        let ship = ShipNode(scale: kShipScale, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.addChild(ship)
        
        let target = AsteroidNode(scaleType: .Big, position: CGPoint(x: self.frame.midX*1.5, y: self.frame.midY*1.5))
        self.addChild(target)
        
        target.movingVector = ship.position - target.position
        target.run(SKAction.move(to: ship.position, duration: 10.0))
        
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
    
        let departure = childNode(withName: kShipName)?.position ?? CGPoint(x: self.frame.midX, y: self.frame.midY)

        let bullet = getBulletNode(position: departure)
        self.addChild(bullet)
        
        let destination = (touchLocation - bullet.position).normalized() * CGPoint(x: 1000, y: 1000) + bullet.position
        
        bullet.run(SKAction.sequence([
            SKAction.move(to: destination, duration: 1.0),
            SKAction.removeFromParent()
        ]))
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
            
            splitAsteroid(asteroid: asteroidNode)
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        } else if nodeNames.contains(kShipName) && nodeNames.contains(kAsteroidName) {
            
        }
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            if let index = contactQueue.firstIndex(of: contact) { contactQueue.remove(at: index) }
      }
    }
}

//MARK: Collision Event
extension GameScene {
    
    func splitAsteroid(asteroid: AsteroidNode) {
        
//        let destination = (touchLocation - bullet.position).normalized() * CGPoint(x: 1000, y: 1000) + bullet.position
        
        
        guard let newSize = AsteroidSize.init(rawValue: asteroid.size.rawValue-1) else { return }
        
        let newAsteroid0 = AsteroidNode(scaleType: newSize, position: asteroid.position)
        let newAsteroid1 = AsteroidNode(scaleType: newSize, position: asteroid.position)
        self.addChild(newAsteroid0)
        self.addChild(newAsteroid1)

        let newDirectionTuple = collisionDirection(current: asteroid.movingVector)
        newAsteroid0.movingVector = newDirectionTuple.0
        newAsteroid0.run(SKAction.move(to: newDirectionTuple.0.normalized() * CGPoint(x: 1000, y: 1000) + asteroid.position, duration: 10.0))
        
        newAsteroid1.movingVector = newDirectionTuple.1
        newAsteroid1.run(SKAction.move(to: newDirectionTuple.1.normalized() * CGPoint(x: 1000, y: 1000) + asteroid.position, duration: 10.0))
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

}
