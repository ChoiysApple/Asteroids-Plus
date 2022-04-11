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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let ship = childNode(withName: kShipName)
        guard let touchLocation = touches.first?.location(in: self) else { return }

        let lookAtConstraint = SKConstraint.orient(to: touchLocation, offset: SKRange(constantValue: -CGFloat.pi / 2))
        ship?.constraints = [ lookAtConstraint ]
    }
    
}
