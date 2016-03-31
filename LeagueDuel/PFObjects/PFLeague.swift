//
//  PFLeague.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse
import Branch

class PFLeague: PFObject, PFSubclassing {
    
    @NSManaged var commissioner: PFDueler!
    @NSManaged var duelers: [String]! // user objectIds
    @NSManaged var name: String?
    @NSManaged var imageURL: String?
    @NSManaged var tagline: String?
    
    class func parseClassName() -> String {
        return "League"
    }
    
    func errorMessageIfInvalid() -> String? {
        if (name ?? "").characters.count == 0 {
            return "Please input a valid name"
        }
        return nil
    }
    
    func isCommissioner() -> Bool {
        return self.commissioner.objectId == PFDueler.currentUser()?.objectId
    }
    
    func canAddAnotherMember() -> Bool {
        return duelers.count < Constants.maxLeagueSize
    }
    
    func getShareURL(completion: ((url: String?) -> Void)?) {
        if let objectId = objectId {
            let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: objectId)
            branchUniversalObject.title = name
            //branchUniversalObject.contentDescription = content.text
            //branchUniversalObject.imageUrl = "https://example.com/mycontent-12345.png"
            branchUniversalObject.addMetadataKey("leagueId", value: objectId)
            
            let linkProperties: BranchLinkProperties = BranchLinkProperties()
            linkProperties.feature = "sharing"
            //linkProperties.channel = "facebook"
            //linkProperties.addControlParam("$desktop_url", withValue: "http://example.com/home")
            //linkProperties.addControlParam("$ios_url", withValue: "http://example.com/ios")
            branchUniversalObject.getShortUrlWithLinkProperties(linkProperties,  andCallback: { (url: String?, error: NSError?) -> Void in
                completion?(url: url)
            })
        } else {
            completion?(url: nil)
        }

    }
    
    class func myLeaguesQuery() -> PFQuery? {
        if let userId = PFDueler.currentUser()?.objectId {
            let query = PFLeague.query()
            query?.whereKey("duelers", containsAllObjectsInArray: [userId])
            return query
        }
        return nil
    }
    
    /*
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
    }*/
    
    class func queryWithIncludes() -> PFQuery? {
        let query = PFLeague.query()
        query?.includeKey("commissioner")
        query?.includeKey("duelers")
        return query
    }

}