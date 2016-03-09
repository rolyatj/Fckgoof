//
//  PFContest.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFContest: PFSuperclass {
    
    @NSManaged var league: PFLeague!
    @NSManaged var event: PFEvent!
    
    class func contestWithSport(sport: SportType, league: PFLeague, event: PFEvent) -> PFContest {
        switch (sport) {
        case .MLB:
            let contest = PFMLBContest()
            contest.league = league
            contest.event = event
            return contest
        }
    }
    
    class func leagueContestsQuery(league: PFLeague, sport: SportType) -> PFQuery? {
        let contestQuery = PFContest.query(sport)
        contestQuery?.whereKey("league", equalTo: league)
        return contestQuery
    }
    
    /*
    class func myLineupsQuery() -> PFQuery? {
    if let leagueQuery = PFLeague.query(), let lineupQuery = PFLineup.queryWithIncludes(), let teamQuery = PFLineup.query(), let user = PFDueler.currentUser(), let userId = user.objectId {
    teamQuery.whereKey("dueler", equalTo: user)
    leagueQuery.whereKey("duelers", containsAllObjectsInArray: [userId])
    lineupQuery.whereKey("league", matchesQuery: leagueQuery)
    return lineupQuery
    }
    return nil
    }
    
    class func myUpcomingLineupsQuery() -> PFQuery? {
    if let eventQuery = PFEvent.query() {
    eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
    let query = PFLineup.myLineupsQuery()
    query?.whereKey("event", matchesQuery: eventQuery)
    return query
    }
    return nil
    }
    
    class func myLiveLineupsQuery() -> PFQuery? {
    if let eventQuery = PFEvent.query() {
    eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
    eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
    let query = PFLineup.myLineupsQuery()
    query?.whereKey("event", matchesQuery: eventQuery)
    return query
    }
    return nil
    }
    
    class func myRecentLineupsQuery() -> PFQuery? {
    if let eventQuery = PFEvent.query() {
    eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
    let query = PFLineup.myLineupsQuery()
    query?.whereKey("event", matchesQuery: eventQuery)
    return query
    }
    return nil
    }*/
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFContest.query(sport)
        query?.includeKey("league")
        query?.includeKey("event")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBContest.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }
    
}
