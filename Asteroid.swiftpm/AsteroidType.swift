//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/11.
//

import SpriteKit

enum AsteroidType: Int {
    case A, B, C
    
    var points: [CGPoint] {
        switch self {
        case .A:
            return [
                CGPoint(x: 2, y: 3),
                CGPoint(x: 3, y: 1),
                CGPoint(x: 2, y: -2),
                CGPoint(x: -1.5, y: -3),
                CGPoint(x: -4, y: -1.5),
                CGPoint(x: -4, y: 2),
                CGPoint(x: -1, y: 4)
            ]

        case .B:
            return [
                CGPoint(x: 1, y: 3),
                CGPoint(x: 0, y: 1),
                CGPoint(x: 3, y: 1),
                CGPoint(x: 3, y: -1),
                CGPoint(x: 0, y: -2),
                CGPoint(x: 1.5, y: -3.5),
                CGPoint(x: -2, y: -3.5),
                CGPoint(x: -4, y: -1.5),
                CGPoint(x: -4, y: 2),
                CGPoint(x: -1, y: 4)
            ]

        case .C:
            return [
                CGPoint(x: 1, y: 4),
                CGPoint(x: 1.5, y: 2),
                CGPoint(x: 3, y: 1),
                CGPoint(x: 3, y: -1),
                CGPoint(x: 1, y: -1.5),
                CGPoint(x: 0.5, y: -3.5),
                CGPoint(x: -2.5, y: -3.5),
                CGPoint(x: -3, y: -1.5),
                CGPoint(x: -5.5, y: -0.5),
                CGPoint(x: -5, y: 2),
                CGPoint(x: -3, y: 2),
                CGPoint(x: -2, y: 4)
            ]
        }
    }
    
    
}

enum AsteroidSize: CGFloat {
    case Big = 15.0
    case Middle = 10.0
    case Small = 5.0
}
