//
//  PFLeague.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLeague: PFObject, PFSubclassing {
    
    @NSManaged var commissioner: PFDueler!
    @NSManaged var duelers: [String]!
    @NSManaged var name: String?
    @NSManaged var imageURL: String?
    @NSManaged var tagline: String?
    
    class func parseClassName() -> String {
        return "League"
    }
    
    class func pinMyLeagues() {
        let query = PFLeague.myLeaguesQuery()
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            PFObject.pinAllInBackground(objects, block: { (success, error) -> Void in
                // TODO?
                NSNotificationCenter.defaultCenter().postNotificationName("pinnedMyLeagues", object: nil)
            })
        })
    }
    
    func setup() {
        self.commissioner = PFDueler.currentUser()!
        self.duelers = [PFDueler.currentUser()!.objectId!]
    }
    
    func isValid() -> String? {
        if (name ?? "").characters.count == 0 {
            return "You need to add a name"
        }
        return nil
    }
    
    func isCommissioner() -> Bool {
        return self.commissioner.objectId == PFDueler.currentUser()?.objectId
    }
    
    class func myLeaguesQuery() -> PFQuery? {
        if let userId = PFDueler.currentUser()?.objectId {
            let query = PFLeague.query()
            query?.whereKey("duelers", containsAllObjectsInArray: [userId])
            return query
        }
        return nil
    }
    
    class func availableLeaguesForEvent(event: PFEvent) -> PFQuery? {
        if let sport = event.dynamicType.sport(), let lineupQuery = PFLineup.myLineupsQuery(sport), let contestQuery = PFContest.query(sport), let contestLineupQuery = PFContestLineup.query(sport) {
            contestLineupQuery.whereKey("event", equalTo: event)
            contestLineupQuery.whereKey("lineup", matchesQuery: lineupQuery)
            contestQuery.whereKey("objectId", matchesKey: "contest.objectId", inQuery: contestLineupQuery)// TODO
            let query = PFLeague.myLeaguesQuery()
            query?.whereKey("objectId", matchesKey: "league.objectId", inQuery: contestLineupQuery)// TODO
            return query
            
        }
        return nil
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFLeague.query()
        query?.includeKey("commissioner")
        return query
    }

}