//
//  CreateLineupViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class CreateLineupViewController: SetLineupViewController {
    
    @IBOutlet weak var selectedLeagueButton: UIButton!
    
    var event: PFEvent!
    
    var league: PFLeague?/* {
        didSet {
            if let selectedLeague = selectedLeague {
                selectedLeagueButton?.setTitle(selectedLeague.name, forState: .Normal)
            } else {
                selectedLeagueButton?.setTitle("Select League", forState: .Normal)
            }
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableContestLineup = EditableContestLineup.editableContestLineupWithEvent(event)
        contestHeaderView.titleLabel.text = event.name
        contestHeaderView.subtitleLabel.text = league?.name?.uppercaseString
    }
    
    @IBAction override func submitTapped(sender: AnyObject) {
        if let errorMessage = editableContestLineup?.checkIfCanSubmit() {
            // TODO
        } else {
            // check if there is an existing contest for selected league
            if let league = league {
                checkIfExistingContest(league, event: event)
            }
        }

    }
    
    func checkIfExistingContest(league: PFLeague, event: PFEvent) {
        if let sport = event.dynamicType.sport() {
            let query = PFContest.query(sport)
            query?.whereKey("league", equalTo: league)
            query?.whereKey("event", equalTo: event)
            query?.getFirstObjectInBackgroundWithBlock({ (contest, error) -> Void in
                if let contest = contest as? PFContest {
                    self.saveToContest(contest)
                } else {
                    // create contest
                    do {
                        let contest = PFContest.contestWithSport(sport, league: league, event: event)
                        try contest.save()
                        self.saveToContest(contest)
                    } catch {
                        // TODO
                        print(error)
                    }
                }
            })
        } else {
            // TODO
        }
    }
    
}
