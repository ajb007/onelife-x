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

class ViewControllerRealm: UIViewController, NSStreamDelegate {

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCircle: UILabel!
    @IBOutlet weak var viewMovement: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textXLocation: UITextField!
    @IBOutlet weak var textYLocation: UITextField!
    @IBOutlet weak var labelMonster: UILabel!
    @IBOutlet weak var textMain: UITextView!
    
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    var messages : NSMutableArray?
    
    let player = Player()
    //let monsters = Monsters()
    var gameTimer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textMain.layer.borderWidth = 1.0;
        viewMovement.layer.borderWidth = 1.0;
        
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
        
        
        //downloadDataFiles()
        initNetworkCommunication()
        //startGameTimer()

    }
    
    @IBAction func buttonMonster(sender: AnyObject) {
        //let amonster = monsters.monster()
        //let name = amonster["name"]
        //labelMonster.text = name as? String
    }
    
    func startGameTimer() {
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "runTimedCode", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonPlayerLoad(sender: AnyObject) {
        GetPlayer()
    }
    
    @IBAction func buttonMove(sender: AnyObject) {
        
        /*
        if player.loaded {
            
            let x: Int64 = Int64(textXLocation.text!)!
            let y: Int64 = Int64(textYLocation.text!)!
            
            player.location.x = x
            player.location.y = y
            
            PlayerAction()
            updateLocation()
        }
        */
        
        sendData(textMain.text)
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
        player.event = A_SPECIFIC
        updateLocation()
        
    }
    
    func updateLocation() {
        
        player.location.beyond = false
        if player.location.x >= Int64(D_BEYOND) || player.location.y >= Int64(D_BEYOND) {
            player.location.beyond = true
        }
        
        /* if moving off the board's edge */
        if (fabs(Double(player.location.x)) >= Double(D_EDGE) || fabs(Double(player.location.x)) >= Double(D_EDGE)) {
            
            /* stop a character at the edge */
            /* send over if they move that way again */
            if Int(fabs(Double(player.location.x))) >= D_EDGE || Int(fabs(Double(player.location.x))) >= D_EDGE && player.specialLocation == PL_EDGE && (player.event == A_SPECIFIC || player.event == A_TELEPORT) {
                        
            }
        }
        
        setCircle(player)
        setLocation(player)
        
        labelLocation.text = player.location.x.description + "," + player.location.y.description
        labelCircle.text = player.location.area! + " (" + player.location.circle.description + ")"
        
        textMain.text = ""
        if player.onPost {
            textMain.text = STR_ON_POST
        }
        
        
        if player.loaded {
            player.event = MOVE_EVENT
            PlayerAction()
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
                    self.player.inRealm = true
                    // ****************************************************
                    
                    // Loading and complete so update location etc
                    self.player.loaded = true
                    self.updateLocation()
                }
        }
    }
    
    func PlayerAction() {
        
        // Stop and restart the timer
        gameTimer.invalidate()
        startGameTimer()
        
        // Put updated player JSON back to DB
        
        let url = "http://localhost:5000/action/2"
        
        var newPost : [String : AnyObject] = [:]
        newPost["name"] = player.name
        newPost["xpos"] = NSNumber(longLong: player.location.x)
        newPost["ypos"] = NSNumber(longLong: player.location.y)
        newPost["event"] = NSNumber(integer: player.event)
        
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
    
    func downloadDataFiles() {
        //downloadDataFile("http://localhost:5000/data/monsters.json")
    }
    
    func runTimedCode() {
        
        sendData("Sending a client timer action")
        
        /*
        let url = "http://localhost:5000/event/2"
        
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
                    let event = playerJSON["event"].int
                    
                    self.labelMonster.text = "Event = " + String(event)
                    
                    print("Response from server received")
                    
                }

        }
        */
    }
    
    func downloadDataFile(dataFileURL: String) {
        let requestURL: NSURL = NSURL(string: dataFileURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
        
                    //if let monsters_js = json["monsters"] as? [[String: AnyObject]] {
                    //    self.monsters.monsters = monsters_js
                    //    print(self.monsters.monsters[0])
                    //}
                    
                }catch {
                    print("Error with Json: \(error)")
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func initNetworkCommunication() {
        
        var readStream : NSInputStream?
        var writeStream : NSOutputStream?
        
        let addr = "127.0.0.1"
        let port = 80
        //var host: NSHost = NSHost(address: addr)
        
        NSStream.getStreamsToHostWithName(addr, port:port, inputStream:&readStream, outputStream:&writeStream)
        
        inputStream = nil
        outputStream = nil
        
        inputStream = readStream!
        outputStream = writeStream!
        
        inputStream?.delegate = self
        outputStream?.delegate = self
        
        inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        
        inputStream?.open()
        outputStream?.open()
        
    }
    
    // Send data back to the server
    func sendData(var data: String) {
        if data == "" {
            data = "tmp"
        }
        var buffer: [UInt8] = Array(data.utf8)
        outputStream!.write(&buffer, maxLength: buffer.count)
    }
    
    // Stream the data back into the client
    func stream(theStream: NSStream, handleEvent streamEvent: NSStreamEvent) {
        switch (streamEvent) {
        //case NSStreamEvent.NSStreamEventNone:
        //    NSLog("No event has occurred")
        case NSStreamEvent.OpenCompleted:
            NSLog("The open has completed successfully")
            
        case NSStreamEvent.HasBytesAvailable:
            var buffer: [UInt8] = [64]
            var output: NSString
            var outStr: String = ""
            NSLog("The stream has bytes to be read")
            while inputStream!.hasBytesAvailable {
                let bytesRead = inputStream!.read(&buffer, maxLength: 64)
                if bytesRead > 0 {
                    output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)!
                    outStr = outStr + String(output)
                }
                
            }
            messageReceived(outStr)
            
        case NSStreamEvent.HasSpaceAvailable:
            NSLog("The stream can accept bytes for writing")
            
        case NSStreamEvent.ErrorOccurred:
            NSLog("An error has occurred on the stream")
            
        case NSStreamEvent.EndEncountered:
            NSLog("The end of the stream has been reached")
            
        default:
            NSLog("Unknown action")
        }

    }
        
    func messageReceived(msg: String) {
        textMain.text = msg
    }
    
}



