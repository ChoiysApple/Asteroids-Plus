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
        
        let ship = ShipNode(scale: 0.0, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        ship.name = "ship"
        self.addChild(ship)
        
        let asteroid = FullAsteroidNode(scale: 10.0, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        asteroid.name = "asteroid"
        self.addChild(asteroid)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let ship = childNode(withName: "ship")!
        let asteroid = childNode(withName: "asteroid")!
        
        ship.run(SKAction.rotate(byAngle: 3, duration: 5.0))
        asteroid.run(SKAction.rotate(byAngle: 3, duration: 5.0))
        
    }
    
    
}
