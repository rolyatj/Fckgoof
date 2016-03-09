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
    @NSManaged var contestId: String?

    class func contestLineupWithSport(sport: SportType, contest: PFContest, lineup: PFLineup) -> PFContestLineup {
        switch (sport) {
        case .MLB:
            let contestLineup = PFMLBContestLineup()
            contestLineup.contest = contest
            contestLineup.lineup = lineup
            contestLineup.contestId = contest.objectId
            return contestLineup
        }
    }

    class func myUpcomingContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let sport = self.sport(), let eventQuery = PFEvent.upcomingEventsQuery(sport), let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport) {
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
        query?.includeKey("contest.league")
        query?.includeKey("lineup")
        query?.includeKey("lineup.playerEvents0")
        query?.includeKey("lineup.playerEvents1")
        query?.includeKey("lineup.playerEvents2")
        query?.includeKey("lineup.playerEvents3")
        query?.includeKey("lineup.playerEvents4")
        query?.includeKey("lineup.playerEvents5")
        query?.includeKey("lineup.playerEvents6")
        query?.includeKey("lineup.playerEvents7")
        query?.includeKey("lineup.playerEvents8")
        query?.includeKey("lineup.playerEvents9")
        query?.includeKey("lineup.playerEvents0.player")
        query?.includeKey("lineup.playerEvents1.player")
        query?.includeKey("lineup.playerEvents2.player")
        query?.includeKey("lineup.playerEvents3.player")
        query?.includeKey("lineup.playerEvents4.player")
        query?.includeKey("lineup.playerEvents5.player")
        query?.includeKey("lineup.playerEvents6.player")
        query?.includeKey("lineup.playerEvents7.player")
        query?.includeKey("lineup.playerEvents8.player")
        query?.includeKey("lineup.playerEvents9.player")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBContestLineup.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }
    
}
