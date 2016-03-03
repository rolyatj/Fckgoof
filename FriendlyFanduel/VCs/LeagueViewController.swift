//
//  LeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var league: PFLeague!
    var events = [PFEvent]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var duelers = [PFDueler]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = league.name?.uppercaseString
        
        if (league.isCommissioner()) {
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editLeague")
            navigationItem.rightBarButtonItem = editButton
        }
        fetchDuelers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fetchDuelers() {
        let query = PFDueler.query()
        query?.whereKey("objectId", containedIn: league.duelers)
        query?.findObjectsInBackgroundWithBlock({ (duelers, error) -> Void in
            if let duelers = duelers as? [PFDueler] {
                self.duelers = duelers
            }
        })
    }
    
    func editLeague() {
        performSegueWithIdentifier("toEditLeague", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toEditLeague") {
            if let editLeagueVC = segue.destinationViewController as? EditLeagueViewController {
                editLeagueVC.league = league
            }
        }
    }

}

extension LeagueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return events.count
        } else {
            return duelers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let event = events[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
            cell.configureWithEvent(event)
            return cell
        } else {
            let dueler = duelers[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("DuelerCell", forIndexPath: indexPath)
            cell.textLabel?.text = dueler.name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
