//
//  LiveContestsViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class LiveContestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var lastRefreshDate = [SportType:NSDate]()
    let sport = SportType.MLB
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateIfNeeded()
    }
    
    func updateIfNeeded() {
        if let lastRefreshDate = lastRefreshDate[sport] {
            if (LDCoordinator.instance.shouldRefresh(lastRefreshDate, sport: SportType.MLB, dateTypes: [DateType.Start, DateType.End])) {
                fetchContests(false)
            }
        } else {
            fetchContests(true)
        }
        
        lastRefreshDate[sport] = NSDate()
    }
    
    func fetchContests(isFirstTime: Bool) {
        print("LIVE fetchContests: \(isFirstTime)")
        let query = PFContestLineup.myLiveContestLineupsQuery(sport)
        if (isFirstTime) {
            query?.cachePolicy = PFCachePolicy.CacheThenNetwork
        } else {
            query?.cachePolicy = PFCachePolicy.NetworkOnly
        }
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
        if (segue.identifier == "toContest") {
            if let vc = segue.destinationViewController as? LeagueContestViewController {
                vc.contest = (sender as? PFContestLineup)?.contest
            }
        }
    }

}

extension LiveContestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contestLineups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContestLineupCell", forIndexPath: indexPath) as! ContestTableViewCell
        let contestLineup = contestLineups[indexPath.row]
        cell.configureWithContestLineup(contestLineup)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let contestLineup = contestLineups[indexPath.row]
        performSegueWithIdentifier("toContest", sender: contestLineup)
    }
    
}