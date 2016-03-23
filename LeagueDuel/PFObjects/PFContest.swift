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
    @NSManaged var leagueId: String?
    @NSManaged var event: PFEvent!
    
    class func contestWithSport(sport: SportType, league: PFLeague, event: PFEvent) -> PFContest {
        switch (sport) {
        case .MLB:
            let contest = PFMLBContest()
            contest.league = league
            contest.leagueId = league.objectId
            contest.event = event
            return contest
        }
    }
    
    class func leagueContestsQuery(league: PFLeague, sport: SportType) -> PFQuery? {
        let contestQuery = PFContest.query(sport)
        contestQuery?.whereKey("league", equalTo: league)
        return contestQuery
    }
    
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
