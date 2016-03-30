//
//  SplashViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import ParseUI

class SplashViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        start()
    }
    
    func start() {
        PFConfig.getConfigInBackgroundWithBlock { (config, error) -> Void in
            let minimumVersion = config?["minimumVersion"] as? String
            let activeSports = config?["activeSports"] as? [Int]
            self.startApp(minimumVersion, activeSports: activeSports)
        }
    }
    
    func startApp(minimumVersion: String?, activeSports: [Int]?) {
        if (isValidAppVersion(minimumVersion)) {
            if let _ = PFDueler.currentUser() {
                if let activeSports = activeSports {
                    var activeSportTypes = [SportType]()
                    for activeSport in activeSports {
                        if let sportType = SportType(rawValue: activeSport) {
                            activeSportTypes.append(sportType)
                        }
                    }
                    print("starting app with active sports: \(activeSportTypes)")
                    LDCoordinator.instance.setupRefreshTimes(activeSportTypes)
                    self.performSegueWithIdentifier("toApp", sender: nil)
                } else {
                    showErrorPopup("The app couldn't start.\n\n1. Please update if you don't have the lastest version\n2. Make sure you have internet access\n\nRestart?", completion: {
                        self.start()
                    })
                }
            } else {
                let loginVC = LogInViewController()
                loginVC.fields = [PFLogInFields.LogInButton, PFLogInFields.UsernameAndPassword, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten]
                loginVC.signUpController = SignUpViewController()
                loginVC.signUpController?.delegate = self
                loginVC.delegate = self
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Sorry!", message: "Your version of the app is outdated. Please update on the App Store to continue using!", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Update", style: .Cancel) { (action) -> Void in
                self.showURL(Constants.AppStoreURL, inapp: false)
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func isValidAppVersion(minimumVersionString: String?) -> Bool {
        var isValid = false
        if let minimumVersionString = minimumVersionString, let currentVersionString = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            if let minimumVersionNumber = versionNumber(minimumVersionString), let currentVersionNumber = versionNumber(currentVersionString) {
                //print("minimum:\(minimumVersionString) current:\(currentVersionString)")
                isValid = currentVersionNumber >= minimumVersionNumber
            }
        }
        return isValid
    }
    
    func versionNumber(versionString: String) -> Int? {
        let versionNumbers = versionString.componentsSeparatedByString(".")
        return Int(versionNumbers.joinWithSeparator(""))
    }
    
}

extension SplashViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    func editProfile() {
        if let nc = storyboard?.instantiateViewControllerWithIdentifier("EditProfileNC") as? UINavigationController {
            presentViewController(nc, animated: true, completion: nil)
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

class LogInViewController: PFLogInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInView?.logo = UILabel()
    }
    
    override func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (textField == self.logInView!.usernameField) {
            textField.text = textField.text?.lowercaseString
        }
        return true
    }
}

class SignUpViewController: PFSignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpView?.logo = UILabel()
    }
    
    override func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (textField == self.signUpView!.usernameField) {
            textField.text = textField.text?.lowercaseString
        }
        return true
    }
}
