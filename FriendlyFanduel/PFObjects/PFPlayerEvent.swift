//
//  PFPlayerEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayerEvent: PFObject, PFSubclassing {
    
    @NSManaged var event: PFEvent!
    @NSManaged var player: PFPlayer!
    @NSManaged var result: PFPlayerEventResult!
    @NSManaged var salary: Int

    
    class func resetPinsForAllPlayersForEvent(event: PFEvent) {
        let localDatastoreQuery = PFPlayerEvent.query()
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
    
    class func pinAllPlayersForEvent(event: PFEvent) {
        let query = PFPlayerEvent.queryWithIncludes()
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

    class func parseClassName() -> String {
        return "PlayerEvent"
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFPlayerEvent.query()
        query?.includeKey("player")
        query?.includeKey("result")
        
        return query
    }

}
