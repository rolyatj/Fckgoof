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
    @NSManaged var contest: PFContest!
    @NSManaged var playerEvents: [PFPlayerEvent]!
    
    class func parseClassName() -> String {
        return "Lineup"
    }
    
    convenience init(contest: PFContest) {
        self.init()
        self.contest = contest
        self.dueler = PFDueler.currentUser()!
        self.playerEvents = [PFPlayerEvent]()
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFLineup.query()
        query?.includeKey("dueler")
        query?.includeKey("lineup")
        query?.includeKey("playerEvents")
        return query
    }
    
    class func myLineupsQuery() -> PFQuery? {
        if let user = PFDueler.currentUser(){
            let query = PFLineup.queryWithIncludes()
            query?.whereKey("dueler", equalTo: user)
            return query
        }
        return nil
    }
    
    class func myUpcominglineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.query()  {
            eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFLineup.myLineupsQuery()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myLivelineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.query() {
            eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFLineup.myLineupsQuery()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myRecentlineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.query() {
            eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFLineup.myLineupsQuery()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
}
