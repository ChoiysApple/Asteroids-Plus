//
//  Shapes.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import Foundation
import SpriteKit

class ShipNode: SKShapeNode {
        
    init(scale: CGFloat, position: CGPoint){
        super.init()
        
        let points = [
            CGPoint(x: 0, y: 10),
            CGPoint(x: 5, y: -5),
            CGPoint(x: 0, y: -2),
            CGPoint(x: -5, y: -5),                                
        ]
        
        let size = CGPoint(x: scale, y: scale)
        let scaledPoints = points.map { $0 * size }
        
        let path = CGMutablePath()
        path.move(to: scaledPoints[0])
        for i in 1...scaledPoints.count-1 {
            path.addLine(to: scaledPoints[i])
        }
        path.addLine(to: scaledPoints[0])

        self.path = path
        self.strokeColor = .white
        self.lineWidth = kLineWidth
        self.position = position
        self.fillColor = kShipLoadedColor
        self.name = kShipName
        
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody?.mass = 1.0
        self.physicsBody?.isDynamic = true
        
        self.physicsBody!.categoryBitMask = kShipCategory
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AsteroidNode: SKShapeNode {
    
    var type = AsteroidType.A
    var size = AsteroidSize.Big
    var movingVector = CGPoint(x: 0, y: 0)
    
    init(scaleType: AsteroidSize, position: CGPoint){
        super.init()
        
        let random = Int.random(in: 0...AsteroidType.allCases.count-1)
        let points = AsteroidType(rawValue: random)?.points ?? AsteroidType.A.points
        
        size = scaleType
        let scale = CGPoint(x: scaleType.scale, y: scaleType.scale)
        let scaledPoints = points.map { $0 * scale }
        
        let path = CGMutablePath()
        path.move(to: scaledPoints[0])
        for i in 1...scaledPoints.count-1 {
            path.addLine(to: scaledPoints[i])
        }
        path.addLine(to: scaledPoints[0])

        self.path = path
        self.strokeColor = .white
        self.fillColor = .black
        self.lineWidth = kLineWidth
        self.position = position
        self.name = kAsteroidName
        
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsBody!.categoryBitMask = kAsteroidCategory
        self.physicsBody!.contactTestBitMask = kShipCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public func getBulletNode(position: CGPoint) -> SKShapeNode {
    let bullet = SKShapeNode(circleOfRadius: kBulletRadius)
    bullet.position = position
    bullet.fillColor = .white
    bullet.zPosition = -10
    bullet.name = kBulletName
    
    bullet.physicsBody = SKPhysicsBody(circleOfRadius: kBulletRadius)
    bullet.physicsBody!.affectedByGravity = false
    bullet.physicsBody!.categoryBitMask = kBulletCategory
    bullet.physicsBody!.contactTestBitMask = kAsteroidCategory
    bullet.physicsBody!.usesPreciseCollisionDetection = true

    
    return bullet
}

public func getLifeItemNode(position: CGPoint) -> SKSpriteNode {
    
    let life = SKSpriteNode(imageNamed: "LifeItem")
    life.size = CGSize(width: life.size.width * 2, height: life.size.height * 2)
    life.position = position
    life.name = kLifeItemName
    
    life.physicsBody = SKPhysicsBody(rectangleOf: life.size)
    life.physicsBody!.affectedByGravity = false
    life.physicsBody!.categoryBitMask = kAsteroidCategory
    life.physicsBody!.usesPreciseCollisionDetection = true
        
    return life
}

public func getBulletItemNode(position: CGPoint) -> SKSpriteNode {
    
    let bullet = SKSpriteNode(imageNamed: "BulletItem")
    bullet.size = CGSize(width: bullet.size.width * 2, height: bullet.size.height * 2)
    bullet.position = position
    bullet.name = kGunItemName
    
    bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
    bullet.physicsBody!.affectedByGravity = false
    bullet.physicsBody!.categoryBitMask = kAsteroidCategory
    bullet.physicsBody!.usesPreciseCollisionDetection = true
        
    return bullet
}


