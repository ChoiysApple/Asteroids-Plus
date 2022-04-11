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
        self.lineWidth = kLineWidth
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FullAsteroidNode: SKShapeNode {
    
    var points = [
        CGPoint(x: 2, y: 3),
        CGPoint(x: 3, y: 1),
        CGPoint(x: 2, y: -2),
        CGPoint(x: -1.5, y: -3),
        CGPoint(x: -4, y: -1.5),
        CGPoint(x: -4, y: 2),
        CGPoint(x: -1, y: 4)
    ]
    
    init(scale: CGFloat, position: CGPoint){
        super.init()
        
        let size = CGPoint(x: scale, y: scale)
        let path = CGMutablePath()
        let scalesPoints = points.map { $0 * size }
        print(scalesPoints)
        
        for i in 0...scalesPoints.count-1 {
            
            if i == 0 {
                path.move(to: scalesPoints[i])
            } else {
                path.addLine(to: scalesPoints[i])
            }
        }
        path.addLine(to: scalesPoints[0])
        
        
        print(path)

        
        self.path = path
        self.strokeColor = .white
        self.lineWidth = kLineWidth
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
