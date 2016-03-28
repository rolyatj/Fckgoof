//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFGame: PFSuperclass {
    
    @NSManaged var homeTeam: PFTeam!
    @NSManaged var awayTeam: PFTeam!
    @NSManaged var event: PFEvent!
    @NSManaged var startDate: NSDate!
    static var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }
    
    func toString() -> String? {
        return "\(awayTeam.teamName ?? "") @ \(homeTeam.teamName ?? "")"
    }
    
    func dateString() -> String? {
        return PFGame.dateFormatter.stringFromDate(startDate)
    }
    
    class func gamesForTeam(sport: SportType, team: PFTeam, event: PFEvent) -> PFQuery? {
        if let queryH = PFGame.query(sport), let queryA = PFGame.query(sport) {
            queryH.whereKey("event", equalTo: event)
            queryA.whereKey("event", equalTo: event)
            queryH.whereKey("homeTeam", equalTo: team)
            queryA.whereKey("awayTeam", equalTo: team)
            let query = PFQuery.orQueryWithSubqueries([queryH, queryA])
            PFGame.addIncludes(query)
            return query
        }
        return nil
    }
    
    class func addIncludes(query: PFQuery) {
        query.includeKey("homeTeam")
        query.includeKey("awayTeam")
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFGame.query(sport)
        query?.includeKey("homeTeam")
        query?.includeKey("awayTeam")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBGame.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }
    
}
