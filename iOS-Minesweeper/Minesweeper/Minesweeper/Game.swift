//
//  GameState.swift
//  Minesweeper
//
//  Created by Patrick on 29.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import UIKit

enum GameStatus : String {
    case Continue = "CONTINUE"
    case GameOver = "GAMEOVER"
    case Victory = "VICTORY"
}

class Cell {
    let x : Int
    let y : Int
    let number : Int
    let flagged : Bool
    let mine : Bool?
    
    init(x : Int, y : Int, number : Int, flagged : Bool, mine : Bool?){
        self.x = x
        self.y = y
        self.number = number
        self.flagged = flagged
        self.mine = mine
    }
}

class Game {
    
    let status:GameStatus
    let visibleCells: [Cell]
    
    init(status : GameStatus, visibleCells : [Cell]) {
        self.status = status
        self.visibleCells = visibleCells
    }
}
