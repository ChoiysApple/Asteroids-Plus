//
//  UserInfo.swift
//  Asteroid+
//
//  Created by Daegeon Choi on 2022/04/13.
//

import Foundation

class UserInfo {
    
    static let shared = UserInfo()

    var score: Int = 0
    var life: Int = 3
    var currnetLevel: Int = 1
    
    func reset() {
        score = 0
        life = 0
        currnetLevel = 1
    }
}
