//
//  MenuViewController.swift
//  GreenFinance
//
//  Created by Kurt Jensen on 3/17/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

class MenuViewController: MessageViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        iapButton.enabled = !Settings.instance.isUpgradedValue()
    }

    @IBAction func purchaseIAPtapped(sender: AnyObject) {
        IAPHelper.instance.purchaseIAP { (success, errorMessage) in
            if (!success) {
                self.showErrorPopup(errorMessage, completion: nil)
            }
            self.iapButton.enabled = !Settings.instance.isUpgradedValue()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else if (section == 1) {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "Feedback"
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "Rate on App Store"
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "Like us on Facebook"
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "Follow us on Twitter"
            } else if (indexPath.row == 2) {
                cell.textLabel?.text = "Share League Duel"
            }
        } else {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "Terms and Conditions"
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "Privacy Policy"
            }
        }

        return cell
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                sendEmail(["arborapps+leagueduel@gmail.com"], subject: "Feedback", body: nil)
            } else if (indexPath.row == 1) {
                //app store
                showURL(Constants.AppStoreURL, inapp: false)
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //"Like us on Facebook"
                showURL("fb://profile/1543903319243024", inapp: false, backupUrlString:"https://www.facebook.com/LeagueDuel")
            } else if (indexPath.row == 1) {
                //"Follow us on Twitter"
                showURL("twitter://user?screen_name=LeagueDuel", inapp: false, backupUrlString:"https://www.twitter.com/LeagueDuel")
            } else if (indexPath.row == 2) {
                //share
                let text = "100% FREE weekly fantasy sports leagues with people you know."
                let url = NSURL(string: Constants.AppStoreURL)!
                let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
                
                activityViewController.excludedActivityTypes = [UIActivityTypePostToWeibo,
                                                                UIActivityTypePrint,
                                                                UIActivityTypeCopyToPasteboard,
                                                                UIActivityTypeAssignToContact,
                                                                UIActivityTypeAddToReadingList,
                                                                UIActivityTypePostToFlickr,
                                                                UIActivityTypePostToVimeo,
                                                                UIActivityTypePostToTencentWeibo,
                                                                UIActivityTypeAirDrop]
                
                self.presentViewController(activityViewController, animated: true, completion: nil)
            }
        } else {
            if (indexPath.row == 0) {
                //"Terms and Conditions"
                showURL("http://www.leagueduelapp.com/terms", inapp: true)
            } else if (indexPath.row == 1) {
                //"Privacy Policy"
                showURL("http://www.leagueduelapp.com/privacy", inapp: true)
            }
        }

    }
}
