//
//  PFMLBPlayerEventResult.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBPlayerEventResult: PFPlayerEventResult, PFSubclassing {
    
    //hitters
    @NSManaged var singles: Int //1pt
    @NSManaged var doubles: Int //2pt
    @NSManaged var triples: Int //3pt
    @NSManaged var homeRuns: Int //4pt
    @NSManaged var runsBattedIn: Int //1pt
    @NSManaged var runsScored: Int //1pt
    @NSManaged var baseOnBalls: Int //1pt
    @NSManaged var stolenBases: Int //2pt
    @NSManaged var hitByPitches: Int //1pt
    @NSManaged var outs: Int //-.25pt
    //pitchers
    @NSManaged var wins: Int //4pts
    @NSManaged var earnedRunsAllowed: Int //-1pts
    @NSManaged var shutOuts: Int //2pts
    @NSManaged var inningsPitched: Int //1pt*Fractional scoring per out.
    
    class func parseClassName() -> String {
        return "MLBPlayerEventResult"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
