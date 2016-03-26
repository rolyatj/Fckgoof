//
//  CreateLineupViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class CreateLineupViewController: SetLineupViewController {
        
    var event: PFEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableContestLineup = EditableContestLineup.editableContestLineupWithEvent(event)
        contestHeaderView.titleLabel.text = event.name
        contestHeaderView.subtitleLabel.text = duelTeam.league?.name?.uppercaseString
    }
    
    @IBAction override func submitTapped(sender: AnyObject) {
        if let errorMessage = editableContestLineup?.errorMessageIfInvalid() {
            showErrorPopup(errorMessage, completion: nil)
        } else {
            // check if there is an existing contest for selected league
            if let duelTeam = duelTeam {
                checkIfExistingContest(duelTeam, event: event)
            }
        }

    }
    
    func checkIfExistingContest(duelTeam: PFDuelTeam, event: PFEvent) {
        if let sport = event.dynamicType.sport() {
            let query = PFContest.query(sport)
            query?.whereKey("league", equalTo: duelTeam.league)
            query?.whereKey("event", equalTo: event)
            query?.getFirstObjectInBackgroundWithBlock({ (contest, error) -> Void in
                if let contest = contest as? PFContest {
                    self.saveToContest(contest)
                } else {
                    // create contest
                    do {
                        let contest = PFContest.contestWithSport(sport, league: duelTeam.league, event: event)
                        try contest.save()
                        self.saveToContest(contest)
                    } catch {
                        self.showErrorPopup((error as NSError).localizedDescription, completion: nil)
                    }
                }
            })
        }
    }
    
}
