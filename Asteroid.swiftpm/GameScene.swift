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
        
        let ship = ShipNode(scale: 4.0, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        
        self.addChild(ship)
        ship.run(SKAction.rotate(byAngle: 3, duration: 5.0))
        
    }
    
    
}
