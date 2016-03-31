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
    @NSManaged var isDeleted: Bool
    
    convenience init(dueler: PFDueler, league: PFLeague) {
        self.init()
        self.dueler = dueler
        self.league = league
    }
    
    func errorMessageIfInvalid() -> String? {
        if (name ?? "").characters.count == 0 {
            return "Please input a valid name"
        }
        return nil
    }
    
    func isOwner() -> Bool {
        return PFDueler.currentUser()?.objectId == dueler.objectId
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
        query?.whereKey("isDeleted", notEqualTo: true)
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
