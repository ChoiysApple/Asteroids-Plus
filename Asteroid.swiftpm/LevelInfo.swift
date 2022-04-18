//
//  UserInfo.swift
//  Asteroid+
//
//  Created by Daegeon Choi on 2022/04/13.
//

import Foundation

class LevelInfo {

    var score: Int = 0
    var life: Int = 3
    var wave: Int = 1
    
    func reset() {
        score = 0
        life = 3
        wave = 1
    }
}
