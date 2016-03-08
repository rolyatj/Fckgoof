//
//  PFSuperclassing.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/5/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import Parse

class PFSuperclass: PFObject {
    
    class func queryWithIncludes(sport: SportType) -> PFQuery? {
        return nil
    }
    class func query(sport: SportType) -> PFQuery? {
        return nil
    }
    class func sport() -> SportType? {
        return nil
    }
    
}

enum SportType: Int {
    case MLB = 0
    
    func searchablePositionString(type: Int) -> String? {
        switch self {
        case .MLB:
            return MLBPosition(rawValue: type)?.toSearchableString()
        }

    }
}

enum MLBPosition : Int {
    case Pitcher = 0
    case Catcher
    case FirstBase
    case SecondBase
    case ShortStop
    case ThirdBase
    case OutField
    case DesignatedHitter
    
    case count
    
    func toSearchableString() -> String? {
        switch self {
        case .Pitcher:
            return "P"
        case .Catcher:
            return "C"
        case .FirstBase:
            return "1B"
        case .SecondBase:
            return "2B"
        case .ShortStop:
            return "SS"
        case .ThirdBase:
            return "3B"
        case .OutField:
            return "F"
        case .DesignatedHitter:
            return "DH"
        default:
            return nil
        }
    }
}

