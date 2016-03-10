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
            let eventQuery = PFEvent.upcomingEventsQuery(sport)
            eventQuery?.whereKey("objectId", doesNotMatchKey: "event.objectId", inQuery: contestQuery)

            return eventQuery
        }
        return nil
    }
 
    class func upcomingEventsQuery(sport: SportType) -> PFQuery? {
        let eventQuery = PFEvent.query(sport)
        eventQuery?.whereKey("openDate", lessThan: NSDate())
        eventQuery?.whereKey("startDate", greaterThan: NSDate())
        return eventQuery
    }
    
    class func liveEventsQuery(sport: SportType) -> PFQuery? {
        let eventQuery = PFEvent.query(sport)
        eventQuery?.whereKey("startDate", lessThan: NSDate())
        eventQuery?.whereKey("endDate", greaterThan: NSDate())
        return eventQuery
    }
    
    class func recentEventsQuery(sport: SportType) -> PFQuery? {
        let eventQuery = PFEvent.query(sport)
        eventQuery?.whereKey("endDate", lessThan: NSDate()) // TODO cap?
        return eventQuery
    }
    
    class func resetPinsForExpiredEvents() {
        let allSports = [SportType.MLB]
        
        for sport in allSports {
            if let liveEventsQuery = liveEventsQuery(sport), let upcomingEventsQuery = upcomingEventsQuery(sport) {
                let query = PFQuery.orQueryWithSubqueries([liveEventsQuery, upcomingEventsQuery])
                let playerEventQuery = PFPlayerEvent.query(sport)
                playerEventQuery?.fromLocalDatastore()
                playerEventQuery?.whereKey("event", doesNotMatchQuery: query)
                playerEventQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    print("found \((objects ?? []).count) player events that were pinned to expired events")
                    PFObject.unpinAllInBackground(objects, block: { (success, error) -> Void in
                        // TODO?
                    })
                })
                let gameQuery = PFGame.query(sport)
                gameQuery?.fromLocalDatastore()
                gameQuery?.whereKey("event", doesNotMatchQuery: query)
                gameQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    print("found \((objects ?? []).count) games that were pinned to expired events")
                    PFObject.unpinAllInBackground(objects, block: { (success, error) -> Void in
                        // TODO?
                    })
                })
            }

        }
        
    }

    func numberOfPositions() -> Int {
        return 0
    }

    func lineupSize() -> Int {
        return 0
    }
    
    func numberOfSpots(position: Int) -> Int {
        return 0
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
        return nil
    }
    
}