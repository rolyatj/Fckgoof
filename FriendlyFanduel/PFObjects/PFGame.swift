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
    
    /*
    class func myGamesQuery() -> PFQuery? {
        if let leagueQuery = PFLeague.query(), let gameQuery = PFGame.queryWithIncludes(), let teamQuery = PFTeam.query(), let user = PFDueler.currentUser(), let userId = user.objectId {
            teamQuery.whereKey("dueler", equalTo: user)
            leagueQuery.whereKey("duelers", containsAllObjectsInArray: [userId])
            gameQuery.whereKey("league", matchesQuery: leagueQuery)
            return gameQuery
        }
        return nil
    }
    
    class func myUpcomingGamesQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query() {
            eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            let query = PFGame.myGamesQuery()
            query?.whereKey("event", matchesQuery: eventQuery)
            return query
        }
        return nil
    }
    
    class func myLiveGamesQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query() {
            eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
            let query = PFGame.myGamesQuery()
            query?.whereKey("event", matchesQuery: eventQuery)
            return query
        }
        return nil
    }
    
    class func myRecentGamesQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query() {
            eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
            let query = PFGame.myGamesQuery()
            query?.whereKey("event", matchesQuery: eventQuery)
            return query
        }
        return nil
    }*/
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFGame.query()
        query?.includeKey("league")
        query?.includeKey("event")
        return query
    }
}
