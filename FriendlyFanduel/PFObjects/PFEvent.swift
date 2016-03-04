//
//  PFEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFEvent: PFObject, PFSubclassing {
    
    @NSManaged var startDate: NSDate!
    @NSManaged var endDate: NSDate!
    @NSManaged var name: String?
    @NSManaged var sport: PFSport!
    
    class func parseClassName() -> String {
        return "Event"
    }
    
    class func availableEventsQuery() -> PFQuery? {
        if let teamQuery = PFLineup.myLineupsQuery(), let contestQuery = PFContest.query() {
            contestQuery.whereKey("objectId", matchesKey:"lineup", inQuery:teamQuery)
            let eventQuery = PFEvent.query()
            eventQuery?.whereKey("startDate", lessThanOrEqualTo: NSDate())
            eventQuery?.whereKey("objectId", doesNotMatchKey: "event", inQuery: contestQuery)
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