//
//  LeaguesViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var leagues = [PFLeague]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchLeagues()
    }
    
    func fetchLeagues() {
        let query = PFLeague.query()
        query?.whereKey("duelers", containsAllObjectsInArray: [PFDueler.currentUser()!.objectId!])
        query?.findObjectsInBackgroundWithBlock({ (leagues, error) -> Void in
            if let leagues = leagues as? [PFLeague] {
                self.leagues = leagues
            }
        })
    }

    func showLeague(league: PFLeague) {
        performSegueWithIdentifier("toLeague", sender: league)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toLeague") {
            if let leagueVC = segue.destinationViewController as? LeagueViewController {
                leagueVC.league = sender as! PFLeague
            }
        }
    }

}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeagueCell", forIndexPath: indexPath) as! LeagueTableViewCell
        let league = leagues[indexPath.row]
        cell.configureWithLeague(league)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let league = leagues[indexPath.row]
        showLeague(league)
    }
    
}