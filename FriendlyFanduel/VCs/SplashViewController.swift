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
        
        if let _ = PFDueler.currentUser() {
            self.performSegueWithIdentifier("toApp", sender: nil)
        } else {
            let loginVC = LogInViewController()
            loginVC.fields = [PFLogInFields.LogInButton, PFLogInFields.UsernameAndPassword, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten]
            loginVC.signUpController = SignUpViewController()
            loginVC.signUpController?.delegate = self
            loginVC.delegate = self
            self.presentViewController(loginVC, animated: true, completion: nil)
        }
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
