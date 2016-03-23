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
    
    func isUpcoming() -> Bool {
        return contest.event.isUpcoming()
    }
    
    func isLive() -> Bool {
        return contest.event.isLive()
    }
    
    func isPast() -> Bool {
        return contest.event.isPast()
    }

    class func myUpcomingContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let user = PFDueler.currentUser() {
            return PFContestLineup.upcomingContestLineupsQueryForUser(sport, user: user)
        }
        return nil
    }
    
    class func myLiveContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let user = PFDueler.currentUser() {
            return PFContestLineup.liveContestLineupsQueryForUser(sport, user: user)
        }
        return nil
    }
    
    class func myRecentContestLineupsQuery(sport: SportType) -> PFQuery? {
        if let user = PFDueler.currentUser() {
            return PFContestLineup.recentContestLineupsQueryForUser(sport, user: user)
        }
        return nil
    }
    
    class func upcomingContestLineupsQueryForUser(sport: SportType, user: PFDueler) -> PFQuery? {
        if let eventQuery = PFEvent.upcomingEventsQuery(sport), let lineupQuery = PFLineup.lineupsQueryForUser(sport, user: user), let contestQuery = PFContest.query(sport) {
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func liveContestLineupsQueryForUser(sport: SportType, user: PFDueler) -> PFQuery? {
        if let eventQuery = PFEvent.liveEventsQuery(sport), let lineupQuery = PFLineup.lineupsQueryForUser(sport, user: user), let contestQuery = PFContest.query(sport) {
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func recentContestLineupsQueryForUser(sport: SportType, user: PFDueler) -> PFQuery? {
        if let eventQuery = PFEvent.recentEventsQuery(sport), let lineupQuery = PFLineup.lineupsQueryForUser(sport, user: user), let contestQuery = PFContest.query(sport) {
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func recentContestLineupsQueryForDuelTeam(sport: SportType, duelTeam: PFDuelTeam) -> PFQuery? {
        if let eventQuery = PFEvent.recentEventsQuery(sport), let lineupQuery = PFLineup.lineupsQueryForDuelTeam(sport, duelTeam: duelTeam), let contestQuery = PFContest.query(sport) {
            contestQuery.whereKey("event", matchesQuery: eventQuery)
            let query = PFContestLineup.queryWithIncludes(sport)
            query?.whereKey("contest", matchesQuery: contestQuery)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            return query
        }
        return nil
    }
    
    class func leagueContestLineupsQuery(sport: SportType, contest: PFContest) -> PFQuery? {
        let query = PFContestLineup.queryWithIncludes(sport)
        query?.whereKey("contest", equalTo: contest)
        return query
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFContestLineup.query(sport)
        query?.includeKey("contest")
        query?.includeKey("contest.league")
        query?.includeKey("contest.event")
        query?.includeKey("lineup")
        query?.includeKey("lineup.duelTeam")
        for i in 0...9 {
            query?.includeKey("lineup.playerEvents\(i)")
            query?.includeKey("lineup.playerEvents\(i).player")
            query?.includeKey("lineup.playerEvents\(i).result")
        }

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
