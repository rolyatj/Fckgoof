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
    @NSManaged var pitcherPlayerEvents: [PFPlayerEvent]!
    @NSManaged var hitterPlayerEvents: [PFPlayerEvent]!
    
    class func parseClassName() -> String {
        return "Lineup"
    }
    
    convenience init(editableContestLineup: EditableContestLineup) {
        self.init()
        self.dueler = PFDueler.currentUser()!
        self.setRoster(editableContestLineup)
    }
    
    func setRoster(editableContestLineup: EditableContestLineup) {
        self.pitcherPlayerEvents = editableContestLineup.hitters
        self.hitterPlayerEvents = editableContestLineup.pitchers
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
