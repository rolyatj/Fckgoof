//
//  PFEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFEvent: PFObject {
    
    @NSManaged var startDate: NSDate!
    @NSManaged var endDate: NSDate!
    @NSManaged var name: String?
    @NSManaged var maxSalary: Int
    
    class func myUpcomingAvailableEventsQuery() -> PFQuery? {
        if let lineupQuery = PFLineup.myLineupsQuery(), let contestQuery = PFContest.query(), let contestLineupQuery = PFContestLineup.query() {
            contestLineupQuery.whereKey("lineup", matchesQuery: lineupQuery)
            contestQuery.whereKey("objectId", matchesKey:"contest.objectId", inQuery: lineupQuery)
            let eventQuery = PFEvent.query()
            eventQuery?.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            eventQuery?.whereKey("objectId", doesNotMatchKey: "event.objectId", inQuery: contestQuery)

            return eventQuery
        }
        return nil
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFEvent.query()
        query?.includeKey("sport")
        return query
    }
    
}