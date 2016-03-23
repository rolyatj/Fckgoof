//
//  EditLineupViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class EditLineupViewController: SetLineupViewController {

    var contestLineup: PFContestLineup!

    override func viewDidLoad() {
        super.viewDidLoad()
        editableContestLineup = EditableContestLineup.editableContestLineupWithLineup(contestLineup)
        contestHeaderView.titleLabel.text = contestLineup.contest.event.name
        contestHeaderView.subtitleLabel.text = contestLineup.contest.league?.name?.uppercaseString
        duelTeam = contestLineup.lineup.duelTeam
    }
    
    @IBAction override func submitTapped(sender: AnyObject) {
        saveToContest(contestLineup.contest)
    }
    
}
