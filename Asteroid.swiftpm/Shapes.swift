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

class AsteroidNode: SKShapeNode {
    
    init(scale: CGFloat, position: CGPoint){
        super.init()
        
        let random = Int.random(in: 0...AsteroidType.allCases.count-1)
        var points = AsteroidType(rawValue: random)?.points ?? AsteroidType.A.points
        
        let size = CGPoint(x: scale, y: scale)
        let path = CGMutablePath()
        let scalesPoints = points.map { $0 * size }
        
        path.move(to: scalesPoints[0])
        for i in 1...scalesPoints.count-1 {
            path.addLine(to: scalesPoints[i])
        }
        path.addLine(to: scalesPoints[0])

        self.path = path
        self.strokeColor = .white
        self.lineWidth = kLineWidth
        self.position = position
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

