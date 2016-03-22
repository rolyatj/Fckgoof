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
    @NSManaged var percentRemaining: Float
    @NSManaged var event: PFEvent!
    @NSManaged var player: PFPlayer!
    @NSManaged var result: PFPlayerEventResult!
    
    func toString() -> String? {
        return "TODO"
    }
    
    class func pinAllPlayersForEvent(event: PFEvent) {
        if let sport = event.dynamicType.sport() {
            let query = PFPlayerEvent.queryWithIncludes(sport)
            query?.limit = 1000
            query?.whereKey("event", equalTo: event)
            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                print("found \((objects ?? []).count) player events to pin for event \(event)")
                PFObject.pinAllInBackground(objects, withName: event.objectId!+"PLAYEREVENT", block: { (success, error) -> Void in
                    // TODO?
                    NSNotificationCenter.defaultCenter().postNotificationName("pinnedPlayerEvents", object: event)
                })
            })
        }
    }
    
    class func recentPlayerEventsForPlayerEvent(sport: SportType, playerEvent: PFPlayerEvent) -> PFQuery? {
        // TODO
        if let recentEventsQuery = PFEvent.liveEventsQuery(sport) {
            let query = PFPlayerEvent.queryWithIncludes(sport)
            query?.whereKey("event", matchesQuery: recentEventsQuery)
            query?.whereKey("player", equalTo: playerEvent.player)
            return query
        }
        return nil
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFPlayerEvent.query(sport)
        query?.includeKey("player")
        query?.includeKey("player.team")
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
        return nil
    }

}
