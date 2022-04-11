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
        
        let target = AsteroidNode(scale: .Big, position: CGPoint(x: self.frame.midX*1.5, y: self.frame.midY*1.5))
        self.addChild(target)
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

//MARK: Physics
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    
    private func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil { return }
      
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(kAsteroidName) && nodeNames.contains(kBulletName) {
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
        } else if nodeNames.contains(kShipName) && nodeNames.contains(kAsteroidName) {
            
            if contact.bodyA.node == childNode(withName: kShipName) {
                contact.bodyB.node!.removeFromParent()
            } else {
                contact.bodyA.node!.removeFromParent()
            }
        }
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            if let index = contactQueue.firstIndex(of: contact) { contactQueue.remove(at: index) }
      }
    }

}
