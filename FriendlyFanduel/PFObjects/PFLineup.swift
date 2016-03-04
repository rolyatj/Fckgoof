//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLineup: PFObject, PFSubclassing {
    
    @NSManaged var dueler: PFDueler!
    @NSManaged var playerEvents: [PFPlayerEvent]!
    
    class func parseClassName() -> String {
        return "Lineup"
    }
    
    convenience init(playerEvents: [PFPlayerEvent]) {
        self.init()
        self.dueler = PFDueler.currentUser()!
        self.playerEvents = [PFPlayerEvent]()
    }
    
    class func myLineupsQuery() -> PFQuery? {
        if let user = PFDueler.currentUser(){
            let query = PFLineup.query()
            query?.whereKey("dueler", equalTo: user)
            return query
        }
        return nil
    }
    
}
