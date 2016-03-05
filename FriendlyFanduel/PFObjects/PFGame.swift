//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFGame: PFSuperclass {
    
    @NSManaged var homeTeam: PFTeam!
    @NSManaged var awayTeam: PFTeam!
    @NSManaged var lineupTime: NSDate!
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFGame.query(sport)
        query?.includeKey("homeTeam")
        query?.includeKey("awayTeam")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBGame.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        if (self.isKindOfClass(PFMLBGame)) {
            return .MLB
        }
        
        return nil
    }
    
}
