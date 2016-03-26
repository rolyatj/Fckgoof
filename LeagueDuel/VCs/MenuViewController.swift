//
//  MenuViewController.swift
//  GreenFinance
//
//  Created by Kurt Jensen on 3/17/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
import SafariServices

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showURL(urlString: String) {
        if let url = NSURL(string: urlString) {
            let svc = SFSafariViewController(URL: url)
            self.presentViewController(svc, animated: true, completion: nil)
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
            return 1
        } else if (section == 0) {
            return 2
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
        if (indexPath.section == 0) {
            cell.textLabel?.text = "Feedback"
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "Like us on Facebook"
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "Follow us on Twitter"
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
            sendEmail()
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //"Like us on Facebook"
            } else if (indexPath.row == 1) {
                //"Follow us on Twitter"
            }
        } else {
            if (indexPath.row == 0) {
                //"Terms and Conditions"
                showURL("http://arborapps.io") // TODO
            } else if (indexPath.row == 1) {
                //"Privacy Policy"
                showURL("http://arborapps.io") // TODO
            }
        }

    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        let mailComposeViewController = emptyMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func emptyMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["arborapps+leagueduel@gmail.com"])
        mailComposerVC.setSubject("Feedback")
        
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            if (result == MFMailComposeResultSent) {
                let alertController = UIAlertController(title: "Feedback Sent", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
}
