//
//  ViewControllerPlayerDetail.swift
//  onelife
//
//  Created by Andy Bartlett on 26/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerPlayerDetail: UIViewController {
    
    var stats: NSMutableArray! = NSMutableArray()
    var player: JSON!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.stats.removeAllObjects()
        self.stats.addObject(["Name", String(player["name"])])
        self.stats.addObject(["Type", String(player["type"])])
        self.stats.addObject(["Gender", String(player["gender"])])
        self.stats.addObject(["Strength", String(player["strength"])])
        self.stats.addObject(["Quickness", String(player["quickness"])])
        self.stats.addObject(["Energy", String(player["energy"])])
        self.stats.addObject(["Brains", String(player["brains"])])
        self.stats.addObject(["Mana", String(player["mana"])])
        self.stats.addObject(["Magic Level", String(player["magicLvl"])])
        self.stats.addObject(["Experience", String(player["experience"])])
        self.stats.addObject(["Gold", String(player["gold"])])
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stats.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? TableViewCellPlayerDetail
        
        let ar = self.stats.objectAtIndex(indexPath.row) as? [String]
        
        cell!.statNameLabel.text = ar![0]
        cell!.statValueLabel.text = ar![1]

        return cell!
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
