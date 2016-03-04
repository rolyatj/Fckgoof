//
//  PFContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFContestLineup: PFObject, PFSubclassing {
    
    @NSManaged var contest: PFContest!
    @NSManaged var lineup: PFLineup!
    
    class func parseClassName() -> String {
        return "ContestLineup"
    }
    
    convenience init(contest: PFContest, lineup: PFLineup) {
        self.init()
        self.contest = contest
        self.lineup = lineup
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFContestLineup.query()
        query?.includeKey("contest")
        query?.includeKey("lineup")
        return query
    }
    
    class func myUpcomingContestLineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.myLineupsQuery()  {
            eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myLiveContestLineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.myLineupsQuery()  {
            eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myRecentContestLineupsQuery() -> PFQuery? {
        if let eventQuery = PFEvent.query(), let lineupQuery = PFLineup.myLineupsQuery()  {
            eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
            lineupQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes()
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
}
