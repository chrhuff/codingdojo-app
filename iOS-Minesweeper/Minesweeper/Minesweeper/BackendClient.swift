//
//  BackendClient.swift
//  Minesweeper
//
//  Created by Patrick on 29.08.15.
//  Copyright © 2015 Patrick. All rights reserved.
//

import Foundation

class BackendClient {
    
    let baseUrl : String
    
    init(baseUrl : String) {
        self.baseUrl = baseUrl
    }
    
    func startGame(width : Int, height : Int, mineRatio : Float, startRequestCompletionHandler : (Int?, String?) -> Void) throws {
        let url : String = "\(baseUrl)/"
        
        let initializer : NSDictionary = NSMutableDictionary()
        initializer.setValue(width, forKey: "width")
        initializer.setValue(height, forKey: "height")
        initializer.setValue(mineRatio, forKey: "mineRatio")
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(initializer, options: NSJSONWritingOptions.PrettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestHandler : StartRequestHandler = StartRequestHandler(completionHandler: startRequestCompletionHandler)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler : requestHandler.restRequestCompletionHandler)
    }
    
    class StartRequestHandler {
        let completionHandler : (Int?, String?) -> Void
        
        init(completionHandler : (Int?, String?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func restRequestCompletionHandler(response:NSURLResponse?, data: NSData?, error: NSError?) {
            if error != nil {
                completionHandler(nil, "Fehler bei REST-call: \(error)")
                return
            }
            
            let dataString : NSString? = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if (dataString == nil) {
                completionHandler(nil, "Kein konformes JSON-Objekt: \(data)")
                return
            }
            
            let gameId : Int = Int(dataString as! String)!
            completionHandler(gameId, nil)
        }

    }
    
    func getGameState(gameId : Int, gameStateRequestCompletionHandler : (Game?, String?) -> Void) throws {
        let url : String = "\(baseUrl)/\(gameId)"
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestHandler : GameStateRequestHandler = GameStateRequestHandler(completionHandler: gameStateRequestCompletionHandler)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler : requestHandler.restRequestCompletionHandler)
    }
    
    func makeMove(gameId : Int, x : Int, y : Int, move : Int, gameStateRequestCompletionHandler : (Game?, String?) -> Void) throws {
        let url : String = "\(baseUrl)/\(gameId)"
        
        let dict2 : NSDictionary = NSMutableDictionary()
        dict2.setValue(x, forKey: "x")
        dict2.setValue(y, forKey: "y")
        let dict1 : NSDictionary = NSMutableDictionary()
        dict1.setValue(move, forKey: "type")
        dict1.setValue(dict2, forKey: "position")

        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "PUT"
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dict1, options: NSJSONWritingOptions.PrettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestHandler : GameStateRequestHandler = GameStateRequestHandler(completionHandler: gameStateRequestCompletionHandler)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler : requestHandler.restRequestCompletionHandler)
    }

    class GameStateRequestHandler {
        let completionHandler : (Game?, String?) -> Void
        
        init(completionHandler : (Game?, String?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func restRequestCompletionHandler(response:NSURLResponse?, data: NSData?, error: NSError?) {
            if error != nil {
                completionHandler(nil, "Fehler bei REST-call: \(error)")
                return
            }
            
            do {
                let dict: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as? NSDictionary
                if (dict == nil) {
                    completionHandler(nil, "Kein konformes JSON-Objekt: \(data)")
                    return
                }
            
                let game : Game? = parseGame(dict!)
                if game != nil {
                    completionHandler(game, nil)
                }
            } catch {
                completionHandler(nil, "Fehler bei JSON-Parsing: \(error)")
            }

        }
        
        func parseGame(dict : NSDictionary) -> Game? {
            var status : GameStatus
            switch(dict.valueForKey("status") as! String) {
            case "GAMEOVER":
                status = GameStatus.GameOver
            case "VICTORY":
                status = GameStatus.Victory
            default:
                status = GameStatus.Continue
            }
            
            var cells : [Cell] = []
            let array : [NSDictionary] = dict.valueForKey("visibleCells") as! [NSDictionary]
            for dictCell in array {
                let x : Int = dictCell.valueForKey("x") as! Int
                let y : Int = dictCell.valueForKey("y") as! Int
                let number : Int = dictCell.valueForKey("number") as! Int
                let flagged : Bool = dictCell.valueForKey("flagged") as! Bool
                let mine : Bool? = dictCell.valueForKey("mine") as? Bool
                let cell : Cell = Cell(x: x, y: y, number: number, flagged: flagged, mine: mine)
                cells.append(cell)
            }
                        
            let game : Game = Game(status: status, visibleCells: cells)
            return game
        }
        
    }
}
