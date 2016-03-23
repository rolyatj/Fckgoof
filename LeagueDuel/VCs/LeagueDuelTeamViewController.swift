//
//  LeagueDuelTeamViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeagueDuelTeamViewController: UIViewController {

    @IBOutlet weak var tableView: LeagueContestTableView!
    var duelTeam: PFDuelTeam!
    var league: PFLeague!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.contestLineups = contestLineups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.lcDelegate = self
        fetchContests()
    }
    
    func fetchContests() {
        let sport = SportType.MLB
        let query = PFContestLineup.recentContestLineupsQueryForDuelTeam(sport, duelTeam: duelTeam)
        query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
            if let contestLineups = contestLineups as? [PFContestLineup] {
                self.contestLineups = contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toPlayerEvent") {
            if let vc = segue.destinationViewController as? PlayerEventViewController {
                vc.playerEvent = sender as! PFPlayerEvent
            }
        }
    }

}

extension LeagueDuelTeamViewController: LeagueContestTableViewDelegate {
    
    func duelTeamTapped(duelTeam: PFDuelTeam) {
        //none performSegueWithIdentifier("toduelTeam", sender:duelTeam)
    }
    
    func playerEventTapped(playerEvent: PFPlayerEvent) {
        performSegueWithIdentifier("toPlayerEvent", sender: playerEvent)
    }
    
}
