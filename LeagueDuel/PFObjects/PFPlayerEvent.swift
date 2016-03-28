//
//  PFPlayerEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayerEvent: PFSuperclass {
    
    @NSManaged var salary: Int
    @NSManaged var percentRemaining: Float
    @NSManaged var event: PFEvent!
    @NSManaged var player: PFPlayer!
    @NSManaged var result: PFPlayerEventResult!

    class func recentPlayerEventsForPlayerEvent(sport: SportType, playerEvent: PFPlayerEvent) -> PFQuery? {
        // TODO?
        if let recentEventsQuery = PFEvent.recentEventsQuery(sport) {
            let query = PFPlayerEvent.queryWithIncludes(sport)
            query?.whereKey("event", matchesQuery: recentEventsQuery)
            query?.whereKey("player", equalTo: playerEvent.player)
            return query
        }
        return nil
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFPlayerEvent.query(sport)
        query?.includeKey("player")
        query?.includeKey("player.team")
        query?.includeKey("result")
        query?.includeKey("event")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBPlayerEvent.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }

}
