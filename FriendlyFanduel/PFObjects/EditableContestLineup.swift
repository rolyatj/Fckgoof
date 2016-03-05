//
//  EditableContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol EditableContestLineupDelegate {
    func editableContestLineupChanged()
}

class EditableContestLineup: NSObject {
    
    var delegate: EditableContestLineupDelegate?
    var event: PFEvent!
    var lineup: PFLineup?
    var swappingPlayerEvent: PFPlayerEvent?
    
    convenience init(event: PFEvent) {
        self.init()
        self.event = event
    }
    
    convenience init(contestLineup: PFContestLineup) {
        self.init()
        self.event = contestLineup.contest.event
        self.lineup = contestLineup.lineup
    }
    
    func currentSalary() -> Int {
        return 0
    }
    
    func lineupSize() -> Int {
        return 0
    }
    
    func maxSalary() -> Int {
        return 0
    }
    
    func disabledPlayerEventIds(filterType: Int) -> [String]? {
        return nil
    }
    
    func checkIfCanSubmit() -> String? {
        // TODO
        return nil
    }
    
    // DATASOURCE
    
    func numberOfPositionsOnRoster() -> Int {
        return 0
    }
    
    func numberOfSpotsForPosition(position: Int) -> Int {
        return 0
    }
    
    func playerEventForPositionSpot(position: Int, spot: Int) -> PFPlayerEvent? {
        return nil
    }
    
}

extension EditableContestLineup: PlayerPickerViewControllerDelegate {
    func playerPickerDidCancel() {
        swappingPlayerEvent = nil
    }
    func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        swappingPlayerEvent = nil
    }
}
