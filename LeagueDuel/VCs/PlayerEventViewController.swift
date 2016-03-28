//
//  PlayerEventViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse
import TwitterKit

enum SelectableType : Int {
    case Add = 0
    case Delete
    
    func imageName() -> String {
        switch (self) {
        case .Add:
            return "Plus-96"
        case .Delete:
            return "Minus-96"
        }
    }
}

class SelectablePlayerEventViewController: PlayerEventViewController {

    var delegate: PlayerPickerViewControllerDelegate?
    var editableContestLineup: EditableContestLineup! {
        didSet {
            self.delegate = editableContestLineup
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectableType = editableContestLineup.hasSelectedPlayerEvent(playerEvent) ? SelectableType.Delete : SelectableType.Add
        let image = UIImage(named:selectableType.imageName())?.imageWithRenderingMode(.AlwaysOriginal)
        let barButtonItem = UIBarButtonItem(image:image, style: .Plain, target: self, action: "togglePlayerEvent:")
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func togglePlayerEvent(sender: AnyObject) {
        delegate?.playerPickerDidSelectPlayerEvent(playerEvent)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class SearchTimelineViewController: TWTRTimelineViewController {
    convenience init(searchString: String) {
        let client = TWTRAPIClient()
        let dataSource = TWTRSearchTimelineDataSource(searchQuery: searchString, APIClient: client)
        
        self.init(dataSource: dataSource)
    }
}

class PlayerEventViewController: UIViewController {
    
    enum PlayerInfoType : Int {
        case None = -1
        case Games
        case Events
        case News
    }
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerPositionLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerInfoLabel: UILabel!
    @IBOutlet weak var playerStatusLabel: UILabel!
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var teamGamesTableView: UITableView!
    @IBOutlet weak var playerEventsTableView: UITableView!
    var playerEvent: PFPlayerEvent!
    var teamGames = [PFGame]() {
        didSet {
            self.teamGamesTableView?.reloadData()
        }
    }
    var recentPlayerEvents = [PFPlayerEvent]() {
        didSet {
            self.playerEventsTableView?.reloadData()
        }
    }
    var hasFetchedPlayerEvents = false
    var hasFetchedTeamGames = false
    var playerInfoType: PlayerInfoType = .None {
        didSet {
            switch (playerInfoType) {
            case .Games:
                if (!hasFetchedTeamGames) {
                    fetchGames()
                }
                playerEventsTableView.hidden = true
                teamGamesTableView.hidden = false
                newsView.hidden = true
                break
            case .Events:
                if (!hasFetchedPlayerEvents) {
                    fetchPlayerEvents()
                }
                playerEventsTableView.hidden = false
                teamGamesTableView.hidden = true
                newsView.hidden = true
                break
            case .News:
                playerEventsTableView.hidden = true
                teamGamesTableView.hidden = true
                newsView.hidden = false
                break
            default:
                playerEventsTableView.hidden = true
                teamGamesTableView.hidden = true
                newsView.hidden = true
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerInfoType = .Games
        
        setupPlayerInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let searchTimelineViewController = SearchTimelineViewController(searchString: playerEvent.player.name ?? "MLB news")
        searchTimelineViewController.willMoveToParentViewController(self)
        newsView.addSubview(searchTimelineViewController.view)
        addChildViewController(searchTimelineViewController)
        searchTimelineViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in newsView.subviews {
            subview.frame = newsView.bounds
        }
    }
    
    func setupPlayerInfo() {
        //@IBOutlet weak var playerImageView: UIImageView!
        playerPositionLabel.text = playerEvent.player.position
        playerNameLabel.text = playerEvent.player.name
        playerInfoLabel.text = playerEvent.player.team?.teamName
        playerStatusLabel.text = "$\(playerEvent.salary)"
    }
    
    func fetchGames() {
        hasFetchedTeamGames = true
        if let sport = playerEvent!.dynamicType.sport(), let team = playerEvent.player.team {
            let query = PFGame.gamesForTeam(sport, team: team, event: playerEvent.event)
            query?.cachePolicy = PFCachePolicy.CacheElseNetwork
            query?.orderByDescending("startDate")
            query?.findObjectsInBackgroundWithBlock({ (teamGames, error) -> Void in
                if let teamGames = teamGames as? [PFGame] {
                    self.teamGames = teamGames
                }
            })
        }
    }
    
    func fetchPlayerEvents() {
        hasFetchedPlayerEvents = true
        if let sport = playerEvent!.dynamicType.sport() {
            let query = PFPlayerEvent.recentPlayerEventsForPlayerEvent(sport, playerEvent: playerEvent)
            query?.cachePolicy = PFCachePolicy.CacheElseNetwork
            query?.orderByDescending("startDate")
            query?.findObjectsInBackgroundWithBlock({ (playerEvents, error) -> Void in
                if let playerEvents = playerEvents as? [PFPlayerEvent] {
                    self.recentPlayerEvents = playerEvents
                }
            })
        }

    }
    
    @IBAction func playerInfoTypeChanged(sender: UISegmentedControl) {
        playerInfoType = PlayerInfoType(rawValue: sender.selectedSegmentIndex) ?? .Games
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

extension PlayerEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == teamGamesTableView) {
            return teamGames.count
        } else {
            return recentPlayerEvents.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == teamGamesTableView) {
            let teamGame = teamGames[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("TeamGameCell", forIndexPath: indexPath)
            cell.textLabel?.text = teamGame.toString()
            cell.detailTextLabel?.text = teamGame.dateString()
            return cell
        } else {
            let recentPlayerEvent = recentPlayerEvents[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerEventCell", forIndexPath: indexPath)
            cell.textLabel?.text = recentPlayerEvent.event.name
            cell.detailTextLabel?.text = recentPlayerEvent.result.resultString()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //TODO?
    }
    
}