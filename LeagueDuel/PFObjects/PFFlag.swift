//
//  PFFlag.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFFlag: PFObject, PFSubclassing {
    
    @NSManaged var userFlagged: PFDueler?
    @NSManaged var teamFlagged: PFDuelTeam?
    @NSManaged var userFlagging: PFDueler?
    
    class func parseClassName() -> String {
        return "Flag"
    }
    
    convenience init(userFlagged: PFDueler, teamFlagged: PFDuelTeam) {
        self.init()
        self.userFlagged = userFlagged
        self.teamFlagged = teamFlagged
        self.userFlagging = PFDueler.currentUser()
    }
}