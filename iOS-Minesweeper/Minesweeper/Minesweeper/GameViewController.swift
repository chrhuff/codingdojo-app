//
//  ViewController.swift
//  Minesweeper
//
//  Created by Patrick on 28.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    var tableViewController : GameTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableViewController = GameTableViewController(x: appDelegate().gameX, y: appDelegate().gameY)
        drawGameField()
        loadGame()
    }
    
    @IBAction func click(sender: UIButton) {
        let button = sender as! GameButton
        clickField(button.x, y: button.y, move: 0)
    }
    
    func loadGame() {
        do {
            try appDelegate().backendClient.getGameState(appDelegate().gameId!, gameStateRequestCompletionHandler : gameStateRequestCompletionHandler)
        } catch {
            showMessage("Fehler", message : " Fehler bei REST-call: \(error)")
            return
        }
    }
    
    func clickField(x : Int, y : Int, move : Int) {
        do {
            try appDelegate().backendClient.makeMove(appDelegate().gameId!, x: x, y: y, move: move, gameStateRequestCompletionHandler : gameStateRequestCompletionHandler)
        } catch {
            showMessage("Fehler", message : " Fehler bei REST-call: \(error)")
            return
        }
        
        indicator.startAnimating()
    }
    
    func gameStateRequestCompletionHandler(game : Game?, errorMessage : String?) {
        indicator.stopAnimating()
        
        if errorMessage != nil {
            showMessage("Fehler", message : errorMessage!)
            return
        }
        
        if game != nil {
            evaluateGame(game!)
        }
    }
    
    func evaluateGame(game : Game) {
        switch(game.status) {
        case .GameOver:
            updateGameField(game.visibleCells)
            //showMessage("Verloren", message: "Das Spiel wurde verloren")
        case .Victory:
            updateGameField(game.visibleCells)
            //showMessage("Gewonnen", message: "Top - gewonnen!")
        case .Continue:
            updateGameField(game.visibleCells)
        }
    }
    
    func updateGameField(cells : [Cell]) {
        for cell in cells {
            if cell.number > 0 {
                tableViewController?.setButtonText(cell.x, y: cell.y, text: String(cell.number))
            }
            
            if cell.mine == true {
                tableViewController?.setButtonColor(cell.x, y: cell.y, color: UIColor.redColor())
                tableViewController?.setButtonText(cell.x, y: cell.y, text: "")
            }
            if cell.mine == false {
                tableViewController?.setButtonColor(cell.x, y: cell.y, color: UIColor.whiteColor())
            }
        }
    }
    
    func drawGameField() {
        tableViewController?.drawButtons(self, action: "click:")
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func showMessage(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func switchToStartView() {
        appDelegate().gameId = nil
        let vc : UIViewController! = self.storyboard!.instantiateViewControllerWithIdentifier("startView")
        self.showViewController(vc, sender: vc)
    }
    
}

