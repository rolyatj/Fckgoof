//
//  PFContest.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFContest: PFObject {
    
    @NSManaged var league: PFLeague!
    @NSManaged var event: PFEvent!
    
    convenience init(league: PFLeague, event: PFEvent) {
        self.init()
        self.league = league
        self.event = event
    }
    
    class  func leagueContestsQuery(league: PFLeague) -> PFQuery? {
        let contestQuery = PFContest.query()
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
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFContest.query()
        query?.includeKey("league")
        query?.includeKey("event")
        return query
    }
    
}
