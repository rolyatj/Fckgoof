//
//  LDTabBarController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LDTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for childViewController in childViewControllers {
            var title: String?
            var imageName = ""
            if let childViewController = childViewController as? UINavigationController {
                if childViewController.childViewControllers.first is LeaguesViewController {
                    title = "LEAGUES"
                    imageName = "Trophy-104"
                } else if childViewController.childViewControllers.first is UpcomingContestsViewController {
                    title = "UPCOMING"
                    imageName = "Future-104"
                } else if childViewController.childViewControllers.first is LiveContestsViewController {
                    title = "LIVE"
                    imageName = "Present-104"
                } else if childViewController.childViewControllers.first is RecentContestsViewController {
                    title = "RECENT"
                    imageName = "Past-104"
                } else if childViewController.childViewControllers.first is ProfileViewController {
                    title = "PROFILE"
                    imageName = "User-104"
                }
            }

            let image = UIImage(named: imageName)?.imageWithRenderingMode(.Automatic)
            let tintImage = UIImage(named: imageName)?.imageWithRenderingMode(.Automatic)
            childViewController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: tintImage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
