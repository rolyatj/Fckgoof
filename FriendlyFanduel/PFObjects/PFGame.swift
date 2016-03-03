//
//  PFGame.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFGame: PFObject, PFSubclassing {
    
    @NSManaged var league: PFLeague!
    @NSManaged var event: PFEvent!
    @NSManaged var teamIds: [String]!
    
    class func parseClassName() -> String {
        return "Game"
    }
    
    convenience init(league: PFLeague, event: PFEvent) {
        self.init()
        self.league = league
        self.event = event
        self.teamIds = [String]()
    }
}