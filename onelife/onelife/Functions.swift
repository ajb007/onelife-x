//
//  Functions.swift
//  onelife
//
//  Created by Andy Bartlett on 11/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import Foundation


func setCircle(player: Player) {
    
    var deltax, deltay, distance, x, y: Double
    
    x = Double(player.location.x)
    y = Double(player.location.y)
    deltax = x-0
    deltay = y-0
    distance = sqrt(deltax * deltax + deltay * deltay)
    let circle = floor(distance / D_CIRCLE + 1)
    player.location.circle = Int64(circle)
    
}

func setLocation(player: Player) {
    
    var quadrant: Int
    let nametable: [[String]] =
    [
        [
            "Anorien","Ithilien","Rohan","Lorien"
        ],
        [
            "Gondor",       "Mordor",       "Dunland",      "Rovanion"
        ],
        [
            "South Gondor", "Khand",        "Eriador",      "The Iron Hills",
        ],
        [
            "Far Harad",    "Near Harad",   "The Northern Waste", "Rhun"
        ]
    ]
    
    if player.inRealm {
        
        if player.location.beyond {
            player.location.area = "The Point of No Return"
        }
        else if player.location.circle >= 400 {
            player.location.area = "The Ashen Mountains"
        }
        else if player.location.circle >= 100 {
            player.location.area = "Kennaquahir"
        }
        else if player.location.circle >= 36 {
            player.location.area = "Morannon"
        }
        else if (player.location.circle == 27) || (player.location.circle == 28) {
            player.location.area = "The Cracks of Doom"
        }
        else if (player.location.circle > 24) && (player.location.circle < 31) {
            player.location.area = "The Plateau of Gorgoroth"
        }
        else if player.location.circle >= 20 {
            player.location.area = "The Dead Marshes"
        }
        else if player.location.circle >= 10 {
            player.location.area = "The Outer Waste"
        }
            else if player.location.circle >= 5 {
            player.location.area = "The Moors Adventurous"
        }
        else {
            quadrant = ((player.location.x > 0) ? 1 : 0);
            quadrant += ((player.location.y >= 0) ? 2 : 0);
            player.location.area = nametable[(player.location.circle) - 1][quadrant]
        }
    }
    else if player.specialLocation == PL_THRONE {
        player.location.area = "The Lord's Chamber"
    }
    else if player.specialLocation == PL_EDGE {
        player.location.area = "Edge Of The Realm"
    }
    else if player.specialLocation == PL_VALHALLA {
        player.location.area = "Valhalla"
    }
    else if (player.specialLocation == PL_PURGATORY) {
        player.location.area = "Purgatory"
    }
    /* no other places to be */
    else {
        player.location.area = "State Of Insanity"
    }
    // LOG Invalid location
    //sprintf(error_msg,
    //    "[%s] Bad c->player.area of %hd in Do_name_location.\n",
    //    c->connection_id, c->player.area);
}