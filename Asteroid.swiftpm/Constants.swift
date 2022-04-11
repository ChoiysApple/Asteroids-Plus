//
//  File.swift
//  Asteroid
//
//  Created by Daegeon Choi on 2022/04/11.
//

import SpriteKit

// Physics Category
let kShipCategory: UInt32 = 0x1 << 0
let kAsteroidCategory: UInt32 = 0x1 << 1
let kBulletCategory: UInt32 = 0x1 << 2

// Common
let kLineWidth: CGFloat = 3.0

// Ship
let kShipScale: CGFloat = 3.5
let kShipName: String = "ship"

// Asteroid
let kAsteroidName: String = "asteroid"

// Bullet
let kBulletName: String = "bullet"
let kBulletRadius: CGFloat = 2.5
