//
//  EditTeamViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/28/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class EditTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var duelTeam: PFDuelTeam!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = duelTeam.imageURL, let url = NSURL(string: imageURL) {
            self.imageView.sd_setImageWithURL(url)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (duelTeam.dirty) {
            duelTeam.revert()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func teamImageTapped(sender: AnyObject) {
        changeTeamImage()
    }
    
    func changeTeamImage() {
        let alertController = UIAlertController(title: "Team Image", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Image URL (ex: www.example.com/url.png)"
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text {
                self.duelTeam.imageURL = text
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
        saveTeam()
    }
    
    func saveTeam() {
        if let errorMessage = duelTeam.errorMessageIfInvalid() {
            showErrorPopup(errorMessage, completion: nil)
        } else {
            duelTeam.saveInBackgroundWithBlock({ (success, error) in
                if (success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
}

extension EditTeamViewController: UITableViewDataSource, UITableViewDelegate, TextFieldTableViewCellDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        if (indexPath.row == 0) {
            cell.textField.placeholder = "Team Name"
            cell.textField.text = duelTeam.name
        } else {
            cell.textField.placeholder = "Tagline (optional)"
        }
        
        return cell
    }
    
    func textChanged(cell: TextFieldTableViewCell, text: String?) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if (indexPath.row == 0) {
                duelTeam.name = text
            } else {
                //team.tagline = text
            }
        }
    }
    
}