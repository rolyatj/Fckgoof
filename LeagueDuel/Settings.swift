//
//  Settings.swift
//  Stack
//
//  Created by Kurt Jensen on 2/29/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    static var instance = Settings()
    
    var isUpgraded : Bool? = NSUserDefaults.standardUserDefaults().boolForKeyOptional(Constants.KEY_IAP) {
        didSet {
            if let isUpgraded = isUpgraded {
                NSUserDefaults.standardUserDefaults().setBool(isUpgraded, forKey: Constants.KEY_IAP)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    var usesPasscode : Bool? = NSUserDefaults.standardUserDefaults().boolForKeyOptional(Constants.KEY_PASSCODE) {
        didSet {
            if let usesPasscode = usesPasscode {
                NSUserDefaults.standardUserDefaults().setBool(usesPasscode, forKey: Constants.KEY_PASSCODE)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    var failedAttempts : [NSDate]? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.KEY_FAILED_ATTEMPTS) as? [NSDate] {
        didSet {
            if let failedAttempts = failedAttempts {
                NSUserDefaults.standardUserDefaults().setObject(failedAttempts, forKey: Constants.KEY_FAILED_ATTEMPTS)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    func isUpgradedValue() -> Bool {
        return isUpgraded ?? false
    }
    func usesPasscodeValue() -> Bool {
        return usesPasscode ?? false
    }
    func failedAttemptsValue() -> [NSDate] {
        return failedAttempts ?? []
    }
    
    func incrementAppLaunches() {
        NSUserDefaults.standardUserDefaults().setInteger(numberOfAppLaunches()+1, forKey: Constants.KEY_NUMBER_APP_LAUNCHES)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func shouldShowAds() -> Bool {
        return numberOfAppLaunches() > 2 && !isUpgradedValue()
    }
    
    func numberOfAppLaunches() -> Int {
        let number = NSUserDefaults.standardUserDefaults().integerForKey(Constants.KEY_NUMBER_APP_LAUNCHES)
        return number
    }
}

extension NSUserDefaults {
    
    func boolForKeyOptional(key: String) -> Bool? {
        var bool: Bool?
        if let object = objectForKey(key) {
            bool = object.boolValue
        }
        return bool
    }
}