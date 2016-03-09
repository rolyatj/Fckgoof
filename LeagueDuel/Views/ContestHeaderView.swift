//
//  ContestHeaderView.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/9/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol ContestHeaderViewDelegate {
    func contestInfoTapped()
}

class ContestHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var delegate: ContestHeaderViewDelegate?
    
    @IBAction func contestInfoTapped(sender: AnyObject) {
        delegate?.contestInfoTapped()
    }
    
    class func contestHeaderView() -> ContestHeaderView {
        let contestHeaderView = NSBundle.mainBundle().loadNibNamed("ContestHeaderView", owner: 0, options: nil)[0] as! ContestHeaderView
        return contestHeaderView
    }

}
