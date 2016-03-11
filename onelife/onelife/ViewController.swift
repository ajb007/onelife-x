//
//  ViewController.swift
//  onelife
//
//  Created by Andy Bartlett on 09/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCircle: UILabel!
    @IBOutlet weak var viewMovement: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textXLocation: UITextField!
    @IBOutlet weak var textYLocation: UITextField!

    
    let player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        viewMovement.addGestureRecognizer(leftSwipe)
        viewMovement.addGestureRecognizer(rightSwipe)
        viewMovement.addGestureRecognizer(upSwipe)
        viewMovement.addGestureRecognizer(downSwipe)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPlayerLoad(sender: AnyObject) {
        GetPlayer()
    }
    
    @IBAction func buttonMove(sender: AnyObject) {
        if player.loaded {
            
            let x: Int64 = Int64(textXLocation.text!)!
            let y: Int64 = Int64(textYLocation.text!)!
            
            player.location.x = x
            player.location.y = y
            
            UpdatePlayer()
            updateLocation()

        }
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        var loc = player.location
        
        if (sender.direction) == .Left {
            loc.x = loc.x-1
        }
        if (sender.direction) == .Right {
            loc.x = loc.x+1
        }
        if (sender.direction) == .Up {
            loc.y = loc.y+1
        }
        if (sender.direction) == .Down {
            loc.y = loc.y-1
        }
        
        player.location = loc
        updateLocation()
        
    }
    
    func updateLocation() {
        
        setCircle(player)
        setLocation(player)
        
        labelLocation.text = player.location.x.description + "," + player.location.y.description
        labelCircle.text = player.location.area! + " (" + player.location.circle.description + ")"
        
        if player.loaded {
            UpdatePlayer()
        }
    }

    
    func GetPlayer() {

        // Get Player JSON from DB by ID
        
        let url = "http://localhost:5000/player/2"
        
        Alamofire.request(.GET, url)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let post = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    //print("The post is: " + post.description)
                    
                    let playerJSON = post["player"]
                    self.player.name = playerJSON["name"].string
                    self.player.location.x = playerJSON["xpos"].int64Value
                    self.player.location.y = playerJSON["ypos"].int64Value
                    self.labelName.text = self.player.name
                    
                    // ****************************************************
                    // Set for now to automatically put player in the realm
                    //self.player.inRealm = true
                    // ****************************************************
                    
                    // Loading and complete so update location etc
                    self.player.loaded = true
                    self.updateLocation()
                }
        }
    }
    
    func UpdatePlayer() {
        
        // Put updated player JSON back to DB
        
        let url = "http://localhost:5000/update/2"
        
        var newPost : [String : AnyObject] = [:]
        newPost["name"] = player.name
        newPost["xpos"] = NSNumber(longLong: player.location.x)
        newPost["ypos"] = NSNumber(longLong: player.location.y)
        
        Alamofire.request(.PUT, url, parameters: newPost, encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /posts/1")
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    // let post = JSON(value)
                    // print("The post is: " + post.description)
                }
        }
    }

}

