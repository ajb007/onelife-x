//
//  ViewControllerPlayerList.swift
//  onelife
//
//  Created by Andy Bartlett on 26/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerPlayerList: UIViewController {
    
    var players: NSMutableArray! = NSMutableArray()
    var players_json = JSON!()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let account_id = OLAccount.instance.id!;
        
        OLRestServerConnection.instance.Get("http://localhost:5000/players/" + String(account_id))
        let json = OLRestServerConnection.instance.lastMessage!
        players_json = json["players"]
        
        self.players.removeAllObjects()
        for index in 0...players_json.count-1 {
            let player = players_json[index][0]
            self.players.addObject([String(player["name"]), String(player["type"]), "0"])
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? TableViewCellPlayerList
        
        let ar = self.players.objectAtIndex(indexPath.row) as? [String]
        cell!.playerNameLabel.text = ar![0]
        cell!.playerTypeLabel.text = ar![1]
        cell!.playerLevelLabel.text = ar![2]
        cell!.playButton.tag = indexPath.row
        cell!.playButton.addTarget(self, action: "playAction:", forControlEvents: .TouchUpInside)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showPlayerDetail", sender: self)
    }
    
    @IBAction func playAction(sender:UIButton) {
        let playerDetail = self.players.objectAtIndex(sender.tag) as? String
        let firstActivityItem = "\(playerDetail)"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showPlayerDetail") {
            let upcoming:ViewControllerPlayerDetail = segue.destinationViewController as! ViewControllerPlayerDetail
            
            let indexPath = self.tableView.indexPathForSelectedRow!
        
            upcoming.player = players_json[indexPath.row][0]
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
    }

}
