//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLineup: PFSuperclass {
    
    @NSManaged var dueler: PFDueler!
    @NSManaged var playerEvents: [PFPlayerEvent]!

    class func lineupFromEditableLineup(sport: SportType, editableContestLineup: EditableContestLineup) -> PFLineup {
        switch (sport) {
        case .MLB:
            return PFMLBLineup(editableContestLineup: editableContestLineup as! MLBEditableContestLineup)
        }
    }
    
    func setRoster(editableContestLineup: EditableContestLineup) {
    }
    
    class func myLineupsQuery(sport: SportType) -> PFQuery? {
        if let user = PFDueler.currentUser(){
            let query = PFLineup.query(sport)
            query?.whereKey("dueler", equalTo: user)
            return query
        }
        return nil
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFLineup.query(sport)
        query?.includeKey("dueler")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBLineup.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }
    
}
