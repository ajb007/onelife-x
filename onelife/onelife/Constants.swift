//
//  Constants.swift
//  onelife
//
//  Created by Andy Bartlett on 11/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import Foundation

// some miscellaneous constants

let D_CIRCLE                        = 125.0         // distance for each circle

// locations within the realm

let PL_REALM                        = 0             // normal coordinates
let	PL_THRONE                       = 1             // In the lord's chamber
let PL_EDGE                         = 2             // On the edge of the realm
let PL_VALHALLA                     = 3             // In Valhalla
let PL_PURGATORY                    = 4             // In purgatory fighting

// event types 
let NULL_EVENT                      = 0             // blank event 
// immediate events 
let KICK_EVENT                      = 1             // get off my game 
let TAG_EVENT                       = 2             // tag yourself 
let REQUEST_DETAIL_EVENT            = 3             // get player info 
let CONNECTION_DETAIL_EVENT         = 4             // another player's info 
let REQUEST_RECORD_EVENT            = 5             // get player info 
let PLAYER_RECORD_EVENT             = 6             // another player's info 
let ADD_PLAYER_EVENT                = 7             // add player info 
let REMOVE_PLAYER_EVENT             = 8             // remove player info 
let CHANGE_PLAYER_EVENT             = 9             // change player info 
let CHAT_EVENT                      = 10            // chat message 
let REPRIMAND_EVENT                 = 11            // Apprentices reprimand 
let UNTAG_EVENT                     = 12            // remove a prefix or suffix 
let UNSUSPEND_EVENT                 = 13            // resume player's game 
let GAME_MARKER                     = 14            // only game events follow 
// ASAP events 
let DEATH_EVENT                     = 20            // player died 
let IT_COMBAT_EVENT                 = 21            // enter interterminal-combat 
let EXPERIENCE_EVENT                = 23            // award the player experience 
// tampering events 
let SUSPEND_EVENT                   = 25            // stop player's game 
let CANTRIP_EVENT                   = 26            // apprentice options 
let MODERATE_EVENT                  = 27            // wizard options 
let ADMINISTRATE_EVENT              = 28            // administrative options 
let VALAR_EVENT                     = 29            // become/lose valar 
let KING_EVENT                      = 30            // become king 
let STEWARD_EVENT                   = 31            // become steward 
let DETHRONE_EVENT                  = 32            // lose king or steward 
let SEX_CHANGE_EVENT                = 34            // toggle player's sex 
let RELOCATE_EVENT                  = 35            // order player to location 
let TRANSPORT_EVENT                 = 36            // transport player 
let CURSE_EVENT                     = 37            // curse player 
let SLAP_EVENT                      = 38            // slap player 
let BLIND_EVENT                     = 39            // blind player 
let BESTOW_EVENT                    = 40            // king bestowed gold 
let SUMMON_EVENT                    = 41            // summon monster for player 
let BLESS_EVENT                     = 42
let HEAL_EVENT                      = 43
let STRONG_NF_EVENT                 = 44            // set the player's strength_nf flag 
let KNIGHT_EVENT                    = 45            // this player has been knighted 
let DEGENERATE_EVENT                = 46
let HELP_EVENT                      = 47            // player is asking for information 

// command events 
let COMMAND_EVENT                   = 48            // the valar uses a power 
let SAVE_EVENT                      = 49            // save the game and quit 
let MOVE_EVENT                      = 50            // move the character 
let EXAMINE_EVENT                   = 51            // examine the stats on a character 
let DECREE_EVENT                    = 52            // make a decree 
let ENACT_EVENT                     = 53            // the steward enacts something 
let LIST_PLAYER_EVENT               = 54            // list the players in the game 
let CLOAK_EVENT                     = 55            // cloak/uncloak 
let TELEPORT_EVENT                  = 56            // teleport player 
let INTERVENE_EVENT                 = 57            // a council uses a power 
let REST_EVENT                      = 58            // rest player 
let INFORMATION_EVENT               = 59            // go to information screen 
let FORCEAGE_EVENT                  = 60            // forcefully age a player 

// normal events 
// events after this are destroyed on orphan 
let DESTROY_MARKER                  = 69
let ENERGY_VOID_EVENT               = 70            // create/hit energy void 
let TROVE_EVENT                     = 71            // find the treasure trove 
let MONSTER_EVENT                   = 72            // encounter monster 
let PLAGUE_EVENT                    = 73            // hit with plague 
let MEDIC_EVENT                     = 74            // encounter medic 
let GURU_EVENT                      = 75            // encounter guru 
let TRADING_EVENT                   = 76            // find a trading post 
let TREASURE_EVENT                  = 77            // find treasure 
let VILLAGE_EVENT                   = 78            // found a village or a volcano 
let TAX_EVENT                       = 79            // encounter tax collector 

// other events
let NATINC_EVENT                    = 84            // restoration of natural stats
let EQINC_EVENT                     = 85            // restoration of equipment 
let CINC_EVENT                      = 86            // restoration of currency 
let AGING_EVENT                     = 87            // Age restore 
let ITEMINC_EVENT                   = 88            // Restores items 


// realm objects 
// events after this are made realm objects on orphan 
let REALM_MARKER                    = 90
let CORPSE_EVENT                    = 91            // find a corpse 
let GRAIL_EVENT                     = 92            // find the holy grail 
let LAST_EVENT                      = 93            // used to find bad events 

// some miscellaneous constants 
let D_BEYOND                        = 1e6           // distance to beyond point of no return
let D_EXPER                         = 2000          // distance experimentos are allowed
let D_EDGE		                    = 100000000     // edge of the world

// constants for altering coordinates 
let A_SPECIFIC                      = 0             // coordinates specified, non-TP
let A_FORCED                        = 1             // coordinates specified, ignore Beyond
let A_NEAR                          = 2             // coordinates not specified, move near
let A_FAR                           = 3             // coordinates not specified, move far
let A_TRANSPORT                     = 4             // distant teleport
let A_OUST                          = 5             // more distant teleport
let A_BANISH                        = 6             // move player to beyond
let A_TELEPORT                      = 7             // moved by teleport
