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
        editableContestLineup = EditableContestLineup(contestLineup: contestLineup)
    }
    
    @IBAction override func submitTapped(sender: AnyObject) {
        saveToContest(contestLineup.contest)
    }
    
}
