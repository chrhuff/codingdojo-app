//
//  GameFieldPickerController.swift
//  Minesweeper
//
//  Created by Patrick on 29.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import UIKit

class GameFieldPickerController : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerData : [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var selectedIndexX : Int = 4
    var selectedIndexY : Int = 4
    
    func selectedWidth() -> Int {
        return Int(pickerData[selectedIndexX])!
    }
    
    func selectedHeight() -> Int {
        return Int(pickerData[selectedIndexY])!
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
        
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedIndexX = row
        }
        if row == 1 {
            selectedIndexY = row
        }
    }
    
}
