//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/08.
//

import Foundation
import SpriteKit

class ShipNode: SKShapeNode {
    
    var pointVector = CGVector(dx: -1, dy: -1)
    
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
        self.name = kShipName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AsteroidNode: SKShapeNode {
    
    var type = AsteroidType.A
    var size = AsteroidSize.Big
    
    init(scale: AsteroidSize, position: CGPoint){
        super.init()
        
        let random = Int.random(in: 0...AsteroidType.allCases.count-1)
        let points = AsteroidType(rawValue: random)?.points ?? AsteroidType.A.points
        let size = CGPoint(x: scale.rawValue, y: scale.rawValue)
        
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

