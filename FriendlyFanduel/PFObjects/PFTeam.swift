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
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFTeam.query()
        query?.includeKey("dueler")
        query?.includeKey("game")
        query?.includeKey("playerEvents")
        return query
    }
    
    class func myTeamsQuery() -> PFQuery? {
        if let teamQuery = PFTeam.queryWithIncludes(), let user = PFDueler.currentUser(){
            teamQuery.whereKey("dueler", equalTo: user)
            return teamQuery
        }
        return nil
    }
    
    class func myUpcomingTeamsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let gameQuery = PFGame.query()  {
            eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            gameQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFTeam.myTeamsQuery()
            query?.whereKey("game", matchesQuery: gameQuery)
            return query
        }
        return nil
    }
    
    class func myLiveTeamsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let gameQuery = PFGame.query() {
            eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
            gameQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFTeam.myTeamsQuery()
            query?.whereKey("game", matchesQuery: gameQuery)
            return query
        }
        return nil
    }
    
    class func myRecentTeamsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let gameQuery = PFGame.query() {
            eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
            gameQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFTeam.myTeamsQuery()
            query?.whereKey("game", matchesQuery: gameQuery)
            return query
        }
        return nil
    }
    
}