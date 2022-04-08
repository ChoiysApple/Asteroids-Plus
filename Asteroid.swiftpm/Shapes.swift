//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import Foundation
import SpriteKit

class ShipNode: SKShapeNode {
    
    init(scale: CGFloat, position: CGPoint){
        super.init()
        
        let size = CGPoint(x: scale, y: scale)
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -10, y: -10) * size)
        path.addLine(to: CGPoint(x: 10, y: 0) * size)
        path.addLine(to: CGPoint(x: 2, y: 2) * size)
        path.addLine(to: CGPoint(x: 0, y: 10) * size)
        path.addLine(to: CGPoint(x: -10, y: -10) * size)

        self.path = path
        self.strokeColor = .white
        self.lineWidth = 3
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
