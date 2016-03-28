//
//  LeagueDuelTeamViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

class LeagueDuelTeamViewController: UIViewController {

    @IBOutlet weak var tableView: LeagueContestTableView!
    @IBOutlet weak var contestsEnteredLabel: UILabel!
    @IBOutlet weak var contestsWonLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let sport = SportType.MLB // TODO
    var duelTeam: PFDuelTeam!
    var league: PFLeague!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.contestLineups = contestLineups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contestsEnteredLabel.text = "\(duelTeam.numberContestsEntered)"
        contestsWonLabel.text = "\(duelTeam.numberContestsWon)"
        
        if let imageURL = duelTeam.imageURL, let url = NSURL(string: imageURL) {
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Team-96"))
        }
        
        tableView.lcDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchContests()
    }
    
    func fetchContests() {
        let query = PFContestLineup.recentContestLineupsQueryForDuelTeam(sport, duelTeam: duelTeam)
        query?.cachePolicy = PFCachePolicy.NetworkElseCache
        query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
            if let contestLineups = contestLineups as? [PFContestLineup] {
                self.contestLineups = contestLineups
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
