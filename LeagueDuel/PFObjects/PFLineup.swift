//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLineup: PFSuperclass {
    
    @NSManaged var points: Float
    @NSManaged var contestId: String?
    @NSManaged var duelTeam: PFDuelTeam!
    @NSManaged var playerEvents0: [PFPlayerEvent]!
    @NSManaged var playerEvents1: [PFPlayerEvent]!
    @NSManaged var playerEvents2: [PFPlayerEvent]!
    @NSManaged var playerEvents3: [PFPlayerEvent]!
    @NSManaged var playerEvents4: [PFPlayerEvent]!
    @NSManaged var playerEvents5: [PFPlayerEvent]!
    @NSManaged var playerEvents6: [PFPlayerEvent]!
    @NSManaged var playerEvents7: [PFPlayerEvent]!
    @NSManaged var playerEvents8: [PFPlayerEvent]!
    @NSManaged var playerEvents9: [PFPlayerEvent]!
    
    class func tempLineupFromEditableLineup(sport: SportType, editableContestLineup: EditableContestLineup) -> PFLineup {
        switch (sport) {
        case .MLB:
            return PFMLBLineup(editableContestLineup: editableContestLineup as! MLBEditableContestLineup)
        }
    }

    class func lineupFromEditableLineup(sport: SportType, duelTeam: PFDuelTeam, contest: PFContest, editableContestLineup: EditableContestLineup) -> PFLineup {
        switch (sport) {
        case .MLB:
            return PFMLBLineup(duelTeam: duelTeam, contest: contest, editableContestLineup: editableContestLineup as! MLBEditableContestLineup)
        }
    }
    
    func setRoster(editableContestLineup: EditableContestLineup) {
    }
    
    
    func positionMapping() -> [Int: [PFPlayerEvent]]? {
        return nil
    }
    
    func allPlayerEvents() -> [PFPlayerEvent] {
        var allPlayers = [PFPlayerEvent]()
        if let playerEvents0 = playerEvents0 {
            allPlayers += playerEvents0
        }
        if let playerEvents1 = playerEvents1 {
            allPlayers += playerEvents1
        }
        if let playerEvents2 = playerEvents2 {
            allPlayers += playerEvents2
        }
        if let playerEvents3 = playerEvents3 {
            allPlayers += playerEvents3
        }
        if let playerEvents4 = playerEvents4 {
            allPlayers += playerEvents4
        }
        if let playerEvents5 = playerEvents5 {
            allPlayers += playerEvents5
        }
        if let playerEvents6 = playerEvents6 {
            allPlayers += playerEvents6
        }
        if let playerEvents7 = playerEvents7 {
            allPlayers += playerEvents7
        }
        if let playerEvents8 = playerEvents8 {
            allPlayers += playerEvents8
        }
        if let playerEvents9 = playerEvents9 {
            allPlayers += playerEvents9
        }
        return allPlayers
    }
    
    class func myLineupsQuery(sport: SportType) -> PFQuery? {
        if let user = PFDueler.currentUser(){
            return PFLineup.lineupsQueryForUser(sport, user: user)
        }
        return nil
    }
    
    class func lineupsQueryForUser(sport: SportType, user: PFDueler) -> PFQuery? {
        if let teamQuery = PFDuelTeam.teamsForUserQuery(user) {
            let query = PFLineup.query(sport)
            query?.whereKey("duelTeam", matchesQuery: teamQuery)
            return query
        }
        return nil
    }
    
    class func lineupsQueryForDuelTeam(sport: SportType, duelTeam: PFDuelTeam) -> PFQuery? {
        let query = PFLineup.query(sport)
        query?.whereKey("duelTeam", equalTo: duelTeam)
        return query
    }
    
    // SUPERCLASSING
    
    override class func queryWithIncludes(sport: SportType) -> PFQuery? {
        let query = PFLineup.query(sport)
        query?.includeKey("duelTeam")
        return query
    }
    
    override class func query(sport: SportType) -> PFQuery? {
        if (sport == .MLB) {
            return PFMLBLineup.query()
        }
        
        return nil
    }
    
    override class func sport() -> SportType? {
        return nil
    }
    
}
