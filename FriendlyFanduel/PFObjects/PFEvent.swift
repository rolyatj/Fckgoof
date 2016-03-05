//
//  PFEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFEvent: PFSuperclass {
    
    @NSManaged var startDate: NSDate!
    @NSManaged var endDate: NSDate!
    @NSManaged var name: String?
    @NSManaged var maxSalary: Int
    
    class func myUpcomingAvailableEventsQuery(sport: SportType) -> PFQuery? {
        if let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport), let contestLineupQuery = PFContestLineup.query(sport) {
            contestLineupQuery.whereKey("lineup", matchesQuery: lineupQuery)
            contestQuery.whereKey("objectId", matchesKey:"contest.objectId", inQuery: lineupQuery)
            let eventQuery = PFEvent.query(sport)
            eventQuery?.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            eventQuery?.whereKey("objectId", doesNotMatchKey: "event.objectId", inQuery: contestQuery)

            return eventQuery
        }
        return nil
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFEvent.query(sport)
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBEvent.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        if (self.isKindOfClass(PFMLBEvent)) {
            return .MLB
        }
        
        return nil
    }
    
}