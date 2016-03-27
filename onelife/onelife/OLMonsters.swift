//
//  Monsters.swift
//  onelife
//
//  Created by Andy Bartlett on 13/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class OLMonsters: NSObject {

    static let instance = OLMonsters()
    var monsters: JSON?
    
    func monster() -> JSON {
        //print(monsters!)
        let random = Int(arc4random_uniform(100))
        let monster = monsters!["monsters"][random]
        return monster
    }
}


// example usage

//let monster = OLMonsters.instance.monster()
//textAccountName.text = String(monster["name"])