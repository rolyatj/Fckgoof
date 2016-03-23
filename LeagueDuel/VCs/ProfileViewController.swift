//
//  ProfileViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaguesLabel: UILabel!
    @IBOutlet weak var contestsEnteredLabel: UILabel!
    @IBOutlet weak var contestsWonLabel: UILabel!

    var duelTeams = [PFDuelTeam]() {
        didSet {
            leaguesLabel?.text = "\(duelTeams.count)"
            var numberContestsEntered = 0
            var numberContestsWon = 0
            for duelTeam in duelTeams {
                numberContestsEntered += duelTeam.numberContestsEntered
                numberContestsWon += duelTeam.numberContestsWon
            }
            contestsEnteredLabel?.text = "\(numberContestsEntered)"
            contestsWonLabel?.text = "\(numberContestsWon)"
            tableView?.reloadData()
        }
    }
    var forceNetwork = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchTeams(forceNetwork)
        forceNetwork = false
    }
    
    func fetchTeams(shouldForceNetwork: Bool) {
        let query = PFDuelTeam.myTeamsQuery()
        if (!shouldForceNetwork) {
            query?.cachePolicy = PFCachePolicy.CacheElseNetwork
        }
        query?.findObjectsInBackgroundWithBlock({ (duelTeams, error) -> Void in
            if let duelTeams = duelTeams as? [PFDuelTeam] {
                self.duelTeams = duelTeams
            }
        })
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        PFDueler.logOutInBackgroundWithBlock { (error) -> Void in
            PFQuery.clearAllCachedResults()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDuelTeam") {
            if let vc = segue.destinationViewController as? LeagueDuelTeamViewController {
                vc.duelTeam = sender as! PFDuelTeam
                vc.league = (sender as! PFDuelTeam).league
            }
        }
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duelTeams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let team = duelTeams[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath)
        cell.textLabel?.text = team.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let team = duelTeams[indexPath.row]
        performSegueWithIdentifier("toDuelTeam", sender: team)
    }
    
}
