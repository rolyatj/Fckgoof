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
    
    @NSManaged var openDate: NSDate!
    @NSManaged var startDate: NSDate!
    @NSManaged var endDate: NSDate!
    @NSManaged var name: String?
    @NSManaged var maxSalary: Int
    @NSManaged var info: String?
    @NSManaged var scoringInfo: String?
    
    static var importableLineups = [PFEvent:PFLineup]()
    static var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }
    
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
    
    func isUpcoming() -> Bool {
        let hasNotStarted = startDate.compare(NSDate()) == .OrderedDescending
        return hasNotStarted
    }
    
    func isLive() -> Bool {
        let hasStarted = startDate.compare(NSDate()) == .OrderedAscending
        let hasNotEnded = endDate.compare(NSDate()) == .OrderedDescending
        return hasStarted && hasNotEnded
    }
    
    func isPast() -> Bool {
        let hasEnded = endDate.compare(NSDate()) == .OrderedAscending
        return hasEnded
    }
    
    func dateString() -> String? {
        return "\(PFEvent.dateFormatter.stringFromDate(startDate)) - \(PFEvent.dateFormatter.stringFromDate(endDate))"
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
    
    func titleForPosition(position: Int) -> String? {
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
        return nil
    }
    
}