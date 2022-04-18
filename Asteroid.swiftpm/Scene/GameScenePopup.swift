//
//  GameScenePopip.swift
//  
//
//  Created by Daegeon Choi on 2022/04/15.
//

import SpriteKit

//MARK: Game Popups
extension GameScene {
    
    func showPopUp() {
        
        let bg = SKShapeNode(rectOf: CGSize(width: self.frame.width*0.5, height: self.frame.height*0.9))
        bg.name = kPopupBGName
        bg.fillColor = .white
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(bg)
        
        let levelLabel = SKLabelNode(text: "You Died")
        levelLabel.name = kPopupTitleName
        levelLabel.fontName = "\(kMenuFontName)-Medium"
        levelLabel.fontColor = .black
        levelLabel.fontSize = 40
        levelLabel.verticalAlignmentMode = .center
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - levelLabel.frame.height*2 - 50)
        levelLabel.zPosition = 10
        self.addChild(levelLabel)
        
        let waveLabel = SKLabelNode(text: "\(wave) Wave Survived")
        waveLabel.name = kPopupScoreName
        waveLabel.fontName = kMenuFontName
        waveLabel.fontColor = .black
        waveLabel.fontSize = 30
        waveLabel.verticalAlignmentMode = .center
        waveLabel.horizontalAlignmentMode = .center
        waveLabel.position = CGPoint(x: self.frame.midX, y: levelLabel.frame.minY - waveLabel.frame.height*2 - 50)
        waveLabel.zPosition = 10
        self.addChild(waveLabel)

        
        let scoreLabel = SKLabelNode(text: "\(score)pt")
        scoreLabel.name = kPopupScoreName
        scoreLabel.fontName = kMenuFontName
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 80
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.frame.midX, y: waveLabel.frame.minY - scoreLabel.frame.height*2 - 20)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
        
        let touchAnywhereLabel = SKLabelNode(text: "> Tap Anywhere to Try Again <")
        touchAnywhereLabel.fontName = kRetroFontName
        touchAnywhereLabel.fontColor = .black
        touchAnywhereLabel.fontSize = 20
        touchAnywhereLabel.position = CGPoint(x: self.frame.midX, y: scoreLabel.frame.minY/2)
        self.addChild(touchAnywhereLabel)
    }
    
    func removePopup() {
        self.childNode(withName: kPopupBGName)?.removeFromParent()
        self.childNode(withName: kPopupTitleName)?.removeFromParent()
        self.childNode(withName: kPopupScoreName)?.removeFromParent()
    }
    
}
