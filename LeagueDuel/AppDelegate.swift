//
//  AppDelegate.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse
import Fabric
import TwitterKit
import Crashlytics
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        IAPHelper.instance.setup()
        
        Twitter.sharedInstance().startWithConsumerKey("Kvd85UhWhdlPRMhl6ahI2brh3", consumerSecret: "oEUIYS3KvXLvDJjlMefsVKuwLeYu2jt1RCTEnKMKrCpUDGYxGc")
        Fabric.with([Crashlytics.self, Twitter.self])

        // PARSE
        PFDueler.registerSubclass()
        PFDuelTeam.registerSubclass()
        PFLeague.registerSubclass()
        PFMLBContest.registerSubclass()
        PFMLBLineup.registerSubclass()
        PFMLBContestLineup.registerSubclass()
        PFMLBEvent.registerSubclass()
        PFMLBPlayer.registerSubclass()
        PFMLBPlayerEvent.registerSubclass()
        PFMLBPlayerEventResult.registerSubclass()
        PFMLBTeam.registerSubclass()
        PFMLBGame.registerSubclass()
        PFSport.registerSubclass()
        PFFlag.registerSubclass()
        //Parse.enableLocalDatastore()
        Parse.setApplicationId("83QAZ8bwzHbXs1i2v526iiv4qJLwkhfQbS9EpB8d",
            clientKey: "POiXIGUX5MbvWagON8sGOd0x9oyellwg0rgH3miD")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // UI APPEARANCE
        UINavigationBar.appearance().barTintColor = UIColor.defaultBarTintColor()
        UINavigationBar.appearance().tintColor = UIColor.defaultTintColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor.defaultBarTintColor()
        UITabBar.appearance().tintColor = UIColor.defaultTintColor()
        UITabBar.appearance().translucent = false
        UIToolbar.appearance().barTintColor = UIColor.defaultBarTintColor()
        UIToolbar.appearance().tintColor = UIColor.defaultTintColor()
        UIToolbar.appearance().translucent = false
        UISearchBar.appearance().barTintColor = UIColor.defaultBarTintColor()
        
        let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]);
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        Branch.getInstance().initSessionWithLaunchOptions(launchOptions, isReferrable: true, andRegisterDeepLinkHandler: { params, error in
            print(params)
            if let params = params {
                if let leagueId = params["leagueId"] as? String {
                    LeaguesViewController.leagueIdToJoin = leagueId
                }
            }
        })
        
        return true
    }

    // PUSH
    
    func application(application: UIApplication, didReceiveRemoteNotification launchOptions: [NSObject: AnyObject]?) -> Void {
        Branch.getInstance().handlePushNotification(launchOptions)
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if let message = userInfo["message"] as? String {
            // TODO
            completionHandler(UIBackgroundFetchResult.NewData)
        }
        else {
            completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        if let user = PFDueler.currentUser() {
            installation.setValue(user, forKey: "user")
        }
        installation.saveInBackground()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Lineups should use this method to pause the lineup.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        Branch.getInstance().handleDeepLink(url)
        
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        Branch.getInstance().continueUserActivity(userActivity)
        return true
    }

}

