//
//  EditLeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

class EditLeagueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!

    var league: PFLeague!
    var duelTeams = [PFDuelTeam]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var duelTeamsToDelete = [PFDuelTeam]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: false)
        fetchDuelers()
        
        if let imageURL = self.league.imageURL, let url = NSURL(string: imageURL) {
            self.imageView.sd_setImageWithURL(url)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (league.dirty) {
            league.revert()
        }
    }
    
    func fetchDuelers() {
        let query = PFDuelTeam.query()
        query?.whereKey("league", equalTo: league)
        query?.findObjectsInBackgroundWithBlock({ (duelTeams, error) -> Void in
            if let duelTeams = duelTeams as? [PFDuelTeam] {
                self.duelTeams = duelTeams
            }
        })
    }
    
    @IBAction func leagueImageTapped(sender: AnyObject) {
        changeLeagueImage()
    }
    
    func changeLeagueImage() {
        let alertController = UIAlertController(title: "League Image", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Image URL (ex: www.example.com/url.png)"
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text {
                self.league.imageURL = text
                if let url = NSURL(string: text) {
                    self.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Camera-104"))
                }
            }
        }
        let searchAction = UIAlertAction(title: "Search", style: .Default) { (action) -> Void in
            self.showURL("http://images.google.com", inapp: false)
        }
        alertController.addAction(searchAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        save()
    }
    
    func save() {
        if let errorMessage = league.errorMessageIfInvalid() {
            showErrorPopup(errorMessage, completion: nil)
        } else {
            if (duelTeamsToDelete.count > 0) {
                PFObject.deleteAllInBackground(duelTeamsToDelete)
            }
            league.saveInBackgroundWithBlock({ (success, error) in
                if (success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
}

extension EditLeagueViewController: UITableViewDataSource, UITableViewDelegate, TextFieldTableViewCellDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return duelTeams.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            if (indexPath.row == 0) {
                cell.textField.placeholder = "League Name"
                cell.textField.text = league.name
            } else {
                cell.textField.placeholder = "Tagline (optional)"
                cell.textField.text = league.tagline
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DuelerCell", forIndexPath: indexPath)
            let duelTeam = duelTeams[indexPath.row]
            cell.textLabel?.text = duelTeam.name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0) {
            return false
        } else {
            let duelTeam = duelTeams[indexPath.row]
            return duelTeam.dueler.objectId != PFDueler.currentUser()?.objectId
        }

    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.section == 0) {
            return UITableViewCellEditingStyle.None
        } else {
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            if (editingStyle == .Delete) {
                let duelTeam = duelTeams[indexPath.row]
                duelTeams.removeAtIndex(indexPath.row)
                league.removeObject(duelTeam.objectId!, forKey: "duelers") // TODO?
                duelTeamsToDelete.append(duelTeam)
            }
        }
    }
    
    func textChanged(cell: TextFieldTableViewCell, text: String?) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    league.name = text
                } else {
                    league.tagline = text
                }
            }
        }
    }
    
}
