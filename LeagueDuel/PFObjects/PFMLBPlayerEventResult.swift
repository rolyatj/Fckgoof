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
    
    @NSManaged var GP: Int
    //hitters
    @NSManaged var hH: Int // per game * 6
    @NSManaged var hHR: Int // per game * 12
    @NSManaged var hRBI: Int // per game * 3
    @NSManaged var hR: Int // per game * 3
    @NSManaged var hBB: Int // per game * 3
    @NSManaged var hSB: Int // per game * 6
    @NSManaged var hHBP: Int // per game * 3
    //pitchers
    @NSManaged var pW: Int // per game * 10
    @NSManaged var pL: Int // per game * -10
    @NSManaged var pSO: Int // per game * 2
    @NSManaged var pER: Int // per game * -3
    @NSManaged var pBB: Int // per game * -0.5
    @NSManaged var pH: Int // per game * -0.5
    @NSManaged var pBF: Int // per game * 0
    @NSManaged var pO: Int // per game / 3
    
    override func resultString() -> String? {
        var resultString = "\(GP)GP:"
        if (hH > 0) {
            resultString += " \(hH)H"
        }
        if (hHR > 0) {
            resultString += " \(hHR) HR"
        }
        if (hRBI > 0) {
            resultString += " \(hRBI) RBI"
        }
        if (hR > 0) {
            resultString += " \(hR) R"
        }
        if (hBB > 0) {
            resultString += " \(hBB) BB"
        }
        if (hSB > 0) {
            resultString += " \(hSB) SB"
        }
        if (hHBP > 0) {
            resultString += " \(hHBP) HBP"
        }

        if (pO > 0) {
            let innings = pO / 3
            let additionalOuts = pO % 3
            resultString += " \(innings).\(additionalOuts) IP"
        }
        if (pW > 0) {
            resultString += " \(pW) W"
        }
        if (pL > 0) {
            resultString += " \(pL) L"
        }
        if (pSO > 0) {
            resultString += " \(pSO) SO"
        }
        if (pER > 0) {
            resultString += " \(pER) ER"
        }
        if (pBB > 0) {
            resultString += " \(pBB) BB"
        }
        /*if (pBF > 0) {
            resultString += "\(pBF) BF"
        }*/

        return resultString
    }
    
    class func parseClassName() -> String {
        return "MLBPlayerEventResult"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
