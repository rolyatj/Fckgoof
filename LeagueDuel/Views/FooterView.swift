//
//  FooterView.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/25/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol FooterViewDelegate {
    func footerViewActionTapped()
}

class FooterView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    var delegate: FooterViewDelegate?
    
    @IBAction func footerViewActionTapped(sender: AnyObject) {
        delegate?.footerViewActionTapped()
    }
    
    class func footerView() -> FooterView {
        let footerView = NSBundle.mainBundle().loadNibNamed("FooterView", owner: 0, options: nil)[0] as! FooterView
        return footerView
    }
    
    class func actionFooterView(delegate:FooterViewDelegate?) -> FooterView {
        let footerView = NSBundle.mainBundle().loadNibNamed("FooterView", owner: 0, options: nil)[1] as! FooterView
        footerView.delegate = delegate
        return footerView
    }
    
}
