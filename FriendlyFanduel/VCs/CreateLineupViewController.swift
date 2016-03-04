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
    var availableLeagues = [PFLeague]() {
        didSet {
            selectedLeague = availableLeagues.first
        }
    }
    
    var selectedLeague: PFLeague? {
        didSet {
            if let selectedLeague = selectedLeague {
                selectedLeagueButton?.setTitle(selectedLeague.name, forState: .Normal)
            } else {
                selectedLeagueButton?.setTitle("Select League", forState: .Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editableContestLineup = EditableContestLineup(event: event)
        
        fetchAvailableLeagues()
    }
    
    func fetchAvailableLeagues() {
        let query = PFLeague.myLeaguesQuery()
        query?.findObjectsInBackgroundWithBlock({ (leagues, error) -> Void in
            if let leagues = leagues as? [PFLeague] {
                self.availableLeagues = leagues
            }
        })
    }
    
    @IBAction func changeLeague(sender: AnyObject) {
        if availableLeagues.count > 1 {
            let alertController = UIAlertController(title: "Which League?", message: nil, preferredStyle: .Alert)
            for league in availableLeagues {
                let sportAction = UIAlertAction(title: league.name, style: .Default) { (action) -> Void in
                    self.selectedLeague = league
                }
                alertController.addAction(sportAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction override func submitTapped(sender: AnyObject) {
        if let errorMessage = editableContestLineup.checkIfCanSubmit() {
            // TODO
        } else {
            // check if there is an existing contest for selected league
            if let selectedLeague = selectedLeague {
                let query = PFContest.query()
                query?.whereKey("league", equalTo: selectedLeague)
                query?.getFirstObjectInBackgroundWithBlock({ (contest, error) -> Void in
                    if let contest = contest as? PFContest {
                        self.saveToContest(contest)
                    } else {
                        // create contest
                        do {
                            let contest = PFContest(league: selectedLeague, event: self.event)
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
    
}
