//
//  MessageViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/31/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import MessageUI

class MessageViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func shareLeague(league: PFLeague) {
        league.getShareURL({ (url) in
            if let leagueId = league.objectId, let url = url {
                let body = "Join my fantasy sports league on the LeagueDuel app!\n\n1. Download the app on the appstore: \(Constants.AppStoreURL)\n2.\n\nTap this link to join my league: \(url)\n\n\nThe league ID is \(leagueId) to join without the link."
                
                let alertController = UIAlertController(title: "Share League?", message: "In order for others to join they will need to enter the unique ID \(leagueId) or go to the included link to download the app and join the league.", preferredStyle: .Alert)
                let textAction = UIAlertAction(title: "Text", style: .Default) { (action) -> Void in
                    self.sendText(body)
                }
                let emailAction = UIAlertAction(title: "Email", style: .Default) { (action) -> Void in
                    self.sendEmail(nil, subject: "Join My League on LeagueDuel", body: body)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(textAction)
                alertController.addAction(emailAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func sendEmail(toEmails: [String]?, subject: String, body: String?) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = mailComposeViewController(toEmails, subject: subject, body: body)
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeViewController(toEmails: [String]?, subject: String, body: String?) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(toEmails)
        mailComposerVC.setSubject(subject)
        if let body = body {
            mailComposerVC.setMessageBody(body, isHTML: false)
        }
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            if (result == MFMailComposeResultSent) {
                let alertController = UIAlertController(title: "Email Sent", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func sendText(body: String?) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposerVC = messageComposerViewController(body)
            self.presentViewController(messageComposerVC, animated: true, completion: nil)
        }
    }
    
    func messageComposerViewController(body: String?) -> MFMessageComposeViewController {
        let messageComposerVC = MFMessageComposeViewController()
        messageComposerVC.messageComposeDelegate = self
        
        messageComposerVC.body = body
        return messageComposerVC
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            if (result == MessageComposeResultSent) {
                let alertController = UIAlertController(title: "Message Sent", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
