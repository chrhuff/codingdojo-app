//
//  GameTableViewController.swift
//  Minesweeper
//
//  Created by Patrick on 30.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import UIKit

class GameTableViewController : NSObject {
    
    let x : Int
    let y : Int
    
    var cells : [[GameButton]] = [[]]
    
    init(x : Int, y : Int) {
        self.x = x
        self.y = y
    }
    
    func drawButtons(eventDelegate : UIViewController, action : Selector) {
        for ix in 0..<x {
            cells.append([])
            for iy in 0..<y {
                let button = GameButton(type: UIButtonType.System)
                let width = CGFloat(300/x)
                let height = CGFloat(300/y)
                var coordX = CGFloat(30 + (Int(width) + 2) * ix)
                var coordY = CGFloat(200 + (Int(height) + 2) * iy)
                
                button.x = ix
                button.y = iy
                button.frame = CGRectMake(coordX, coordY, width, height)
                button.backgroundColor = UIColor.lightGrayColor()
                button.setTitle("", forState: UIControlState.Normal)
                eventDelegate.view.addSubview(button)
                button.addTarget(eventDelegate, action: action, forControlEvents: UIControlEvents.TouchUpInside)
                
                cells[ix].append(button)
            }
        }
    }
    
    func setButtonText(x : Int, y : Int, text : String) {
        cells[x][y].setTitle(text, forState: UIControlState.Normal)
    }
    
    func setButtonColor(x : Int, y : Int, color : UIColor) {
        cells[x][y].backgroundColor = color
    }
    
}

class GameButton : UIButton {
    
    var x : Int = 0
    var y : Int = 0
    
}
    