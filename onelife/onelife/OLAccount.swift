//
//  OLAccount.swift
//  onelife
//
//  Created by Andy Bartlett on 19/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class OLAccount: NSObject {
    
    static let instance = OLAccount()
    var loggedIn:Bool = false

    // Account information
    var id: NSInteger?              // Account unique identifier
    var	name: NSString?		        // account name
    var	lcname: NSString?	        // name in lowercase
    var password: NSString?         // password hash
    var	last_reset: NSDate?	        // time of last password reset
    var	email:NSString?	            // creator e-mail
    var	lcemail:NSString?           // e-mail in lowercase
    var	confirmation:Bool?          // first time confirmation
    
    // Creation information
    var parent_IP:NSString?         // created from this address
    var parent_network:NSString?    // created from this address
    var date_created:NSDate?        // created at this time
    
    // previous user information
    var last_IP:NSString?           // last IP or DNS address
    var last_network:NSString?      // last IP or DNS address
    var last_load:NSDate?		    // time last accessed
    var login_count:NSInteger?	    // number of times account used
    
    // hack foilers
    var bad_passwords:NSInteger?    // unsuccessful load attempts
    var hack_count:NSInteger?		// number of alleged hacks
    var reject_count:NSInteger?	    // times given a reject tag
    var last_hack:NSDate?		    // time of the last hack
    var mute_count:NSInteger?		// times given a reject tag
    var last_mute:NSDate?		    // time of the last hack
    
    override init() {

        id = 0
        name = ""
        lcname = name?.lowercaseString
        password = ""
        last_reset = NSDate()
        email = ""
        lcemail = email?.lowercaseString
        confirmation = false
        parent_IP = ""
        parent_network = ""
        date_created = NSDate()
        last_IP = parent_IP
        last_network = parent_network
        last_load = NSDate()
        login_count = 0
        bad_passwords = 0
        hack_count = 0
        reject_count = 0
        last_hack = nil
        mute_count = 0
        last_mute = nil
    
        super.init()
    }
    
    func json() -> [String:AnyObject] {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        //quadrant = ((player.location.x > 0) ? 1 : 0);
        
        let string = ((last_mute == nil) ? "" : dateFormatter.stringFromDate(last_mute!))
        
        //let string = dateFormatter.stringFromDate(last_mute!)
        print(string)
        
        let jsonObject: [String: AnyObject] = [
            "payload":"account",
            "account": [
                "main": [
                    "id":id!,
                    "name":name!,
                    "lcname":lcname!,
                    "password":password!,
                    "last_reset":(last_reset == nil) ? "" : dateFormatter.stringFromDate(last_reset!),
                    "email":email!,
                    "lcemail":lcemail!,
                    "confirmation":confirmation!
                ],
                "creation": [
                    "parent_IP":parent_IP!,
                    "parent_network":parent_network!,
                    "date_created":(date_created == nil) ? "" : dateFormatter.stringFromDate(date_created!),
                ],
                "previous": [
                    "last_IP":parent_IP!,
                    "last_network":parent_network!,
                    "last_load":(last_load == nil) ? "" : dateFormatter.stringFromDate(last_load!),
                    "login_count":login_count!
                ],
                "hack_foilers": [
                    "bad_passwords":bad_passwords!,
                    "hack_count":hack_count!,
                    "reject_count":reject_count!,
                    "last_hack":(last_hack == nil) ? "" : dateFormatter.stringFromDate(last_hack!),
                    "mute_count":mute_count!,
                    "last_mute":(last_mute == nil) ? "" : dateFormatter.stringFromDate(last_mute!)
                ]
            ]
        ]
        
        //let valid = NSJSONSerialization.isValidJSONObject(jsonObject)
        //print(valid)
        
        return jsonObject
    }
    
    func set(json: JSON) {
        let dateFormatter = NSDateFormatter()
        let account = json["account"]
        let main = account["main"]
        let creation = account["creation"]
        let previous = account["previous"]
        let hack = account["hack_foilers"]
        
        id = (main["id"].intValue)
        name = (main["name"].stringValue)
        lcname = (main["lcname"].stringValue)
        password = (main["password"].stringValue)
        last_reset = (main["last_reset"].stringValue == "") ? nil : dateFormatter.dateFromString(main["last_reset"].stringValue)
        email = (main["email"].stringValue)
        lcemail = (main["lcemail"].stringValue)
        confirmation = (main["confirmation"].boolValue)
        parent_IP = (creation["parent_IP"].stringValue)
        parent_network = (creation["parent_network"].stringValue)
        date_created = (creation["date_created"].stringValue == "") ? nil : dateFormatter.dateFromString(creation["date_created"].stringValue)
        last_IP = parent_IP
        last_network = parent_network
        last_load = (previous["last_load"].stringValue == "") ? nil : dateFormatter.dateFromString(previous["last_load"].stringValue)
        login_count = (previous["login_count"].intValue)
        bad_passwords = (hack["bad_passwords"].intValue)
        hack_count = (hack["hack_count"].intValue)
        reject_count = (hack["reject_count"].intValue)
        last_hack = nil
        mute_count = (hack["mute_count"].intValue)
        last_mute = nil

    }
    
}
