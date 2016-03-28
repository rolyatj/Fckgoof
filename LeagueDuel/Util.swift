//
//  Util.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/25/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import SafariServices

class MessageViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
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

extension UIViewController {
    func showPopup(title: String?, message: String?, completion: (() -> Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            completion?()
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showErrorPopup(message: String?, completion: (() -> Void)? ) {
        showPopup("Error", message: message, completion: completion)
    }
    
    func showURL(urlString: String, inapp: Bool) {
        if let url = NSURL(string: urlString) {
            if (inapp) {
                let svc = SFSafariViewController(URL: url)
                self.presentViewController(svc, animated: true, completion: nil)
            } else {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
    
}

extension NSDate {
    func timeAgo(numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return "\(components.year)y ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1y ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month)m ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1m ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear)w ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1w ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day)d ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1d ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour)h ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1h ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute)m ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1m ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second)s ago"
        } else {
            return "Just now"
        }
        
    }
}