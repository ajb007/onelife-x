//
//  OLPlayerTypes.swift
//  onelife
//
//  Created by Andy Bartlett on 23/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON

struct OLPlayerType {
    
    var name: NSString?
    var abbrv: NSString?
    var maxBrains: NSNumber?
    var maxMana: NSNumber?
    var weakness: NSNumber?
    var goldTote: NSNumber?
    var ringDuration: NSNumber?
    var base: NSInteger?
    var interval: NSInteger?
    var quickness: NSNumber?
    var strength: NSNumber?
    var mana: NSNumber?
    var energy: NSNumber?
    var brains: NSNumber?
    var magicLvl: NSNumber?

}

class OLPlayerTypes: NSObject {
    
    static let instance = OLPlayerTypes()
    var playerTypes: JSON?
    
    func playerType(id: NSInteger) -> JSON {
        let playerType = playerTypes![id]
        return playerType
    }
    
    func playerTypeAr() -> [String] {
        var ar = [String]()
        for (_, subJson) in playerTypes!["playerTypes"] {
            print(subJson["name"])
            ar.append(String(subJson["name"]))
        }
        return ar
    }

}