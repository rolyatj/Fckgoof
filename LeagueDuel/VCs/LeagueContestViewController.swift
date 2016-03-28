//
//  LeagueContestViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class LeagueContestViewController: UIViewController {

    @IBOutlet weak var tableView: LeagueContestTableView!
    var contest: PFContest!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.contestLineups = contestLineups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = contest.event.name
        tableView.lcDelegate = self
        fetchContests(true)
        tableView.tableFooterView = UIView()
    }
    
    func fetchContests(isFirstTime: Bool) {
        if let sport = contest!.dynamicType.sport() {
            let query = PFContestLineup.leagueContestLineupsQuery(sport, contest:contest)
            if (contest.event.isLive()) {
                if (isFirstTime) {
                    query?.cachePolicy = PFCachePolicy.CacheThenNetwork
                } else {
                    query?.cachePolicy = PFCachePolicy.NetworkOnly
                }
            } else {
                query?.cachePolicy = PFCachePolicy.IgnoreCache
            }
            query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
                if let contestLineups = contestLineups as? [PFContestLineup] {
                    self.contestLineups = contestLineups
                }
            })
            self.performSelector("fetchContests:", withObject: false, afterDelay: 30)
        }
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
        } else if (segue.identifier == "toDuelTeam") {
            if let vc = segue.destinationViewController as? LeagueDuelTeamViewController {
                vc.duelTeam = sender as! PFDuelTeam
                vc.league = contest.league
            }
        }
    }
    

}

extension LeagueContestViewController: LeagueContestTableViewDelegate {
    
    func duelTeamTapped(duelTeam: PFDuelTeam) {
        performSegueWithIdentifier("toDuelTeam", sender:duelTeam)
    }
    
    func playerEventTapped(playerEvent: PFPlayerEvent) {
        performSegueWithIdentifier("toPlayerEvent", sender: playerEvent)
    }
    
}
