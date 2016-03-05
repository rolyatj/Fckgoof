//
//  PFContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFContestLineup: PFSuperclass {
    
    @NSManaged var contest: PFContest!
    @NSManaged var lineup: PFLineup!
    
    convenience init(contest: PFContest, lineup: PFLineup) {
        self.init()
        self.contest = contest
        self.lineup = lineup
    }

    class func myUpcomingContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let sport = self.sport(), let eventQuery = PFEvent.query(sport), let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport) {
            eventQuery.whereKey("startDate", greaterThanOrEqualTo: NSDate())
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myLiveContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let sport = self.sport(), let eventQuery = PFEvent.query(sport), let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport) {
            eventQuery.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery.whereKey("endDate", greaterThanOrEqualTo: NSDate())
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func myRecentContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let sport = self.sport(), let eventQuery = PFEvent.query(sport), let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport) {
            eventQuery.whereKey("endDate", lessThanOrEqualTo: NSDate())
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFContestLineup.query(sport)
        query?.includeKey("contest")
        query?.includeKey("lineup")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBContestLineup.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        if (self.isKindOfClass(PFMLBContestLineup)) {
            return .MLB
        }
        
        return nil
    }
    
}
