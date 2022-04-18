//
//  AsteroidType.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/11.
//

import SpriteKit

enum AsteroidType: Int, CaseIterable {
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

enum AsteroidSize: Int {
    case Big = 2
    case Middle = 1
    case Small = 0
    
    var scale: CGFloat {
        switch self {
        case .Big: return 15.0
        case .Middle: return 10.0
        case .Small: return 5.0
        }
    }
    
    var score: Int {
        switch self {
        case .Big: return 120
        case .Middle: return 110
        case .Small: return 100
        }
    }
}

enum AsteroidSplitType: Int, CaseIterable {
    case DiagonalDown = 0          // \
    case Horizontal = 1            // -
    case DiagonalUp = 2            // /
}

