//
//  PFPlayerEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayerEvent: PFSuperclass {
    
    @NSManaged var salary: Int
    @NSManaged var event: PFEvent!
    @NSManaged var player: PFPlayer!
    @NSManaged var result: PFPlayerEventResult!
    
    class func resetPinsForAllPlayersForEvent(event: PFEvent) {
        if let sport = event.dynamicType.sport() {
            let localDatastoreQuery = PFPlayerEvent.query(sport)
            localDatastoreQuery?.fromLocalDatastore()
            localDatastoreQuery?.whereKey("event", notEqualTo: event)
            localDatastoreQuery?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                print("found \((objects ?? []).count) objects that were pinned not belonging to this event \(event)")
                PFObject.unpinAllInBackground(objects, block: { (success, error) -> Void in
                    // TODO?
                    PFPlayerEvent.pinAllPlayersForEvent(event)
                })
            })
        }

    }
    
    class func pinAllPlayersForEvent(event: PFEvent) {
        if let sport = event.dynamicType.sport() {
            let query = PFPlayerEvent.queryWithIncludes(sport)
            query?.limit = 1000
            query?.whereKey("event", equalTo: event)
            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                print("found \((objects ?? []).count) objects to pin for event \(event)")
                PFObject.pinAllInBackground(objects, block: { (success, error) -> Void in
                    // TODO?
                    NSNotificationCenter.defaultCenter().postNotificationName("pinnedPlayerEvents", object: event)
                })
            })
        }
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFPlayerEvent.query(sport)
        query?.includeKey("player")
        query?.includeKey("result")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBPlayerEvent.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        if (self.isKindOfClass(PFMLBPlayerEvent)) {
            return .MLB
        }
        
        return nil
    }

}
