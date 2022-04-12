//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/12.
//

import SpriteKit

extension GameScene {

    func makeExplosion(position: CGPoint) {
        
        let length = kExplosionLength
        let duration = kExplosionDuration
        let radius: CGFloat = 0.5
        
        let dot1 = SKShapeNode(circleOfRadius: radius)
        dot1.position = position
        dot1.fillColor = .white
        let dot2 = SKShapeNode(circleOfRadius: radius)
        dot2.position = position
        dot2.fillColor = .white
        let dot3 = SKShapeNode(circleOfRadius: radius)
        dot3.position = position
        dot3.fillColor = .white
        let dot4 = SKShapeNode(circleOfRadius: radius)
        dot4.position = position
        dot4.fillColor = .white
        let dot5 = SKShapeNode(circleOfRadius: radius)
        dot5.position = position
        dot5.fillColor = .white
        let dot6 = SKShapeNode(circleOfRadius: radius)
        dot6.position = position
        dot6.fillColor = .white
        let dot7 = SKShapeNode(circleOfRadius: radius)
        dot7.position = position
        dot7.fillColor = .white
        let dot8 = SKShapeNode(circleOfRadius: radius)
        dot8.position = position
        dot8.fillColor = .white

        
        
        let dots: [SKShapeNode] = [ dot1, dot2, dot3, dot4, dot5, dot6, dot7, dot8 ]
        dots.forEach { self.addChild($0) }
        
        let destination = [
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0.7, y: -0.7),
            CGPoint(x: 0, y: -1),
            CGPoint(x: -0.7, y: -0.7),
            CGPoint(x: -1, y: 0),
            CGPoint(x: -0.7, y: 0.7),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0.7, y: 0.7)
        ]
        
        for i in 0...dots.count-1 {
            
            let move = SKAction.move(to: destination[i] * CGPoint(x: length, y: length) + position, duration: duration)
            let remove = SKAction.removeFromParent()
                        
            dots[i].run(SKAction.sequence([move, remove]))
        }
        
    }
    
}
