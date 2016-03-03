//
//  PFTeam.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFTeam: PFObject, PFSubclassing {
    
    @NSManaged var dueler: PFDueler!
    @NSManaged var game: PFGame!
    @NSManaged var playerEvents: [PFPlayerEvent]!
    
    class func parseClassName() -> String {
        return "Team"
    }
    
    convenience init(game: PFGame) {
        self.init()
        self.game = game
        self.dueler = PFDueler.currentUser()!
        self.playerEvents = [PFPlayerEvent]()
    }
}