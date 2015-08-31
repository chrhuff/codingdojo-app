//
//  StartViewController.swift
//  Minesweeper
//
//  Created by Patrick on 29.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import UIKit

class StartViewController : UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var pickerXY: UIPickerView!
    @IBOutlet var sliderMineRatio: UISlider!
    @IBOutlet var labelMineRatio: UILabel!
    
    let pickerXYcontroller : GameFieldPickerController = GameFieldPickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickerXY.delegate = pickerXYcontroller
        self.pickerXY.dataSource = pickerXYcontroller
        self.pickerXY.selectRow(pickerXYcontroller.selectedIndexX, inComponent: 0, animated: false)
        self.pickerXY.selectRow(pickerXYcontroller.selectedIndexY, inComponent: 1, animated: false)
        
        self.activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func sliderRatioChanged(sender: UISlider) {
        labelMineRatio.text = "\(Int(sliderMineRatio.value))"
    }
    
    @IBAction func click(sender: UIButton) {
        startGame()
    }
    
    func startGame() {
        let width : Int = pickerXYcontroller.selectedWidth()
        let height : Int = pickerXYcontroller.selectedHeight()
        let mineRatio : Float = sliderMineRatio.value/100
        
        do {
            try appDelegate().backendClient.startGame(width, height: height, mineRatio: mineRatio, startRequestCompletionHandler: completionHandler)
        } catch {
            showError("Fehler", message : " Fehler bei REST-call: \(error)")
            return
        }
        
        self.activityIndicator.startAnimating()
    }
    
    func completionHandler(gameId : Int?, errorMessage : String?) {
        self.activityIndicator.stopAnimating()
        if errorMessage != nil {
            showError("Fehler", message : errorMessage!)
            return
        }
        
        if gameId != nil {
            switchToGameView(gameId!)
        }
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func showError(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func switchToGameView(gameId : Int) {
        appDelegate().gameId = gameId
        appDelegate().gameX = pickerXYcontroller.selectedWidth()
        appDelegate().gameY = pickerXYcontroller.selectedHeight()
        let vc : UIViewController! = self.storyboard!.instantiateViewControllerWithIdentifier("gameView")
        self.showViewController(vc, sender: vc)
    }
    
}
