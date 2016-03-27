//
//  Player.swift
//  onelife
//
//  Created by Andy Bartlett on 11/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import Foundation

struct Location {
    var x:  Int64 = 0
    var y:  Int64 = 0
    var circle: Int64 = 0
    var area: String?
    var beyond: Bool = false
}

class Player {
    var name: String?
    var location = Location()
    var loaded : Bool = false
    var inRealm : Bool = false
    var specialLocation: Int = 0
    var onPost : Bool = false
    var cloaked : Bool = false
    var event: Int = 0
}