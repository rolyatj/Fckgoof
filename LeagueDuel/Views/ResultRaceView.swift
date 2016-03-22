//
//  ResultRaceView.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class ResultRaceView: UIView {
    
    var allPlayerView = UIView()
    var currentPlayerView = UIView()
    var leaderPlayerView = UIView()
    var currentPlayerLabel = UILabel()
    var leaderPlayerLabel = UILabel()
    var currentPlayerImageView = UIImageView(image: UIImage(named:""))
    var leaderPlayerImageView = UIImageView(image: UIImage(named:""))
    var numberOfPlayers = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendSubviewToBack(currentPlayerImageView)
        sendSubviewToBack(leaderPlayerImageView)
        sendSubviewToBack(currentPlayerView)
        sendSubviewToBack(leaderPlayerView)
        sendSubviewToBack(allPlayerView)
    }
    
    func reloadData(currentPlayerIndex: Int, leaderPlayerIndex: Int, currentPlayerScore: Float, leaderPlayerScore: Float) {
        allPlayerView.backgroundColor = UIColor.lightGrayColor()
        leaderPlayerView.backgroundColor = UIColor.greenColor()
        currentPlayerView.backgroundColor = UIColor.redColor()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
