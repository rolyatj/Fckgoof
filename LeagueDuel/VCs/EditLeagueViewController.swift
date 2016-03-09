//
//  EditLeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class EditLeagueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueNameButton: UIButton!

    var league: PFLeague!
    var duelers = [PFDueler]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leagueNameButton.setTitle(league.name, forState: .Normal)
        tableView.setEditing(true, animated: false)
        fetchDuelers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (league.dirty) {
            league.revert()
        }
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
    
    @IBAction func leagueNameTapped(sender: AnyObject) {
        editLeagueName()
    }
    
    func editLeagueName() {
        let alertController = UIAlertController(title: "League Name", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // TODO
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text where text.characters.count > 0 {
                self.league.name = text
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        save()
    }
    
    func save() {
        league.saveInBackgroundWithBlock({ (success, error) -> Void in
            if (success) {
                // TODO SHARE
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // TODO
            }
        })
    }
    
}

extension EditLeagueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duelers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DuelerCell", forIndexPath: indexPath)
        let dueler = duelers[indexPath.row]
        cell.textLabel?.text = dueler.username
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let dueler = duelers[indexPath.row]
        return dueler.objectId != PFDueler.currentUser()?.objectId
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let dueler = duelers[indexPath.row]
            duelers.removeAtIndex(indexPath.row)
            league.removeObject(dueler.objectId!, forKey: "duelers")
        }
    }
    
}