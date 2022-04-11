//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import SpriteKit

class GameScene: SKScene {
        
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        let ship = ShipNode(scale: kShipScale, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.addChild(ship)
                
    }
    
    override func update(_ currentTime: TimeInterval) {
                
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self) {
            orientShip(point: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self) {
            orientShip(point: point)
        }
    }
    
    private func orientShip(point: CGPoint) {
        let ship = childNode(withName: kShipName)

        let lookAtConstraint = SKConstraint.orient(to: point, offset: SKRange(constantValue: -CGFloat.pi / 2))
        ship?.constraints = [ lookAtConstraint ]
    }
    
}
