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
    @NSManaged var playerEvents0: [PFPlayerEvent]!
    @NSManaged var playerEvents1: [PFPlayerEvent]!
    @NSManaged var playerEvents2: [PFPlayerEvent]!
    @NSManaged var playerEvents3: [PFPlayerEvent]!
    @NSManaged var playerEvents4: [PFPlayerEvent]!
    @NSManaged var playerEvents5: [PFPlayerEvent]!
    @NSManaged var playerEvents6: [PFPlayerEvent]!
    @NSManaged var playerEvents7: [PFPlayerEvent]!
    @NSManaged var playerEvents8: [PFPlayerEvent]!
    @NSManaged var playerEvents9: [PFPlayerEvent]!

    class func lineupFromEditableLineup(sport: SportType, editableContestLineup: EditableContestLineup) -> PFLineup {
        switch (sport) {
        case .MLB:
            return PFMLBLineup(editableContestLineup: editableContestLineup as! MLBEditableContestLineup)
        }
    }
    
    func setRoster(editableContestLineup: EditableContestLineup) {
    }
    
    
    func positionMapping() -> [Int: [PFPlayerEvent]]? {
        return nil
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
