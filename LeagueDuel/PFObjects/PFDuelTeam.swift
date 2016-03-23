//
//  PFDuelTeam.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFDuelTeam: PFObject, PFSubclassing {

    @NSManaged var name: String?
    @NSManaged var imageURL: String?
    @NSManaged var numberContestsEntered: Int
    @NSManaged var numberContestsWon: Int
    @NSManaged var dueler: PFDueler!
    @NSManaged var league: PFLeague!
    
    convenience init(dueler: PFDueler, league: PFLeague) {
        self.init()
        self.dueler = dueler
        self.league = league
    }
    
    class func myTeamsQuery() -> PFQuery? {
        if let user = PFDueler.currentUser() {
            return PFDuelTeam.teamsForUserQuery(user)
        }
        return nil
    }
    
    class func teamsForUserQuery(user: PFDueler) -> PFQuery? {
        let query = PFDuelTeam.queryWithIncludes()
        query?.whereKey("dueler", equalTo: user)
        return query
    }
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFDuelTeam.query()
        query?.includeKey("dueler")
        query?.includeKey("league")
        return query
    }
    
    class func parseClassName() -> String {
        return "DuelTeam"
    }
    
}
