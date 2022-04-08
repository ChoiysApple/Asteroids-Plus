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
        
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 200, y: 50))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addLine(to: CGPoint(x: 200, y: 50))
        path.addLine(to: .zero)
        
        let shape = SKShapeNode(path: path)
        shape.strokeColor = .white
        shape.lineWidth = 1
        shape.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(shape)
        
        
    }
    
    
}
