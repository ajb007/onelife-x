//
//  OLRestServerConnection.swift
//  onelife
//
//  Created by Andy Bartlett on 19/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class OLRestServerConnection: NSObject {
    
    static let instance = OLRestServerConnection()
    
    var lastMessage: JSON?
    let semaphore = dispatch_semaphore_create(0)
    
    private override init() {
        // no need to init anything at this stage
        super.init()
    }

    func Post(url:String, json:[String:AnyObject]) {
        
        Alamofire.request(.POST, url, parameters: json, encoding: .JSON)
            .responseJSON {
            response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on " + url)
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    dispatch_semaphore_signal(self.semaphore)
                    let post = JSON(value)
                    self.handleResponse(post)
                }
        }
        //Wait for the request to complete
        while dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) != 0 {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 10))
        }
    }
    
    func Get(url:String) {
        
        // Get Player JSON from DB by ID
        
        Alamofire.request(.GET, url)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on " + url)
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    dispatch_semaphore_signal(self.semaphore)
                    let post = JSON(value)
                    self.handleResponse(post)
                }
            
        }
        //Wait for the request to complete
        while dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) != 0 {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 10))
        }
    }
    
    func Put(url:String, json:[String:AnyObject]) {
        Alamofire.request(.PUT, url, parameters: json, encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on " + url)
                    print(response.result.error!)
                    return
                }
                
                if let value: AnyObject = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    dispatch_semaphore_signal(self.semaphore)
                    let post = JSON(value)
                    self.handleResponse(post)
                }
        }
        //Wait for the request to complete
        while dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) != 0 {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 10))
        }
    }
    
    func Delete(url:String) {
        Alamofire.request(.DELETE, url)
            .responseJSON { response in
                if let error = response.result.error {
                    // got an error while deleting, need to handle it
                    print("error calling DELETE on " + url)
                    print(error)
                    
                    // Need to handle the response here
                    
                    
                }
        }
    }
    
    func handleResponse(json: JSON) {
        self.lastMessage = json
        //print(json)
    }
    
    
}
