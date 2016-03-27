//
//  ViewControllerCreatePlayer.swift
//  onelife
//
//  Created by Andy Bartlett on 22/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit

class ViewControllerCreatePlayer: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate {

    var stats: NSMutableArray! = NSMutableArray()
    var playerTypePickerDataSource = OLPlayerTypes.instance.playerTypeAr();
    var genderPickerDataSource = ["Male", "Female"]
    var playerType = ""
    
    @IBOutlet weak var playerTypePicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.playerTypePicker.dataSource = self;
        self.playerTypePicker.delegate = self;

        
        //let playerType = playerTypePicker.selectedRowInComponent(<#T##component: Int##Int#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playerTypePickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return playerTypePickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        playerType = playerTypePickerDataSource[row]
    }
    
    @IBAction func generateButton(sender: AnyObject) {
        
        OLRestServerConnection.instance.Get("http://localhost:5000/create_player/" + playerType)
        
        let player = OLRestServerConnection.instance.lastMessage!
        
        self.stats.removeAllObjects()
        self.stats.addObject(["Name", String(nameTextField.text!)])
        self.stats.addObject(["Type", String(player["type"])])
        self.stats.addObject(["Gender", (genderSegment.selectedSegmentIndex == 0) ? "Male" : "Female"])
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
    @IBAction func saveButton(sender: AnyObject) {
        
        let stats = OLRestServerConnection.instance.lastMessage!
        var statsd = convertStringToDictionary(String(stats))
        
        statsd!["account_id"] = OLAccount.instance.id
        statsd!["account"] = OLAccount.instance.name
        statsd!["name"] = nameTextField.text!
        if genderSegment.selectedSegmentIndex == 0 {
            statsd!["gender"] = "Male"
        }
        else {
            statsd!["gender"] = "Female"
        }
        print(statsd!)
        OLRestServerConnection.instance.Post("http://localhost:5000/save_player", json: statsd!)
        
        let theResult = OLRestServerConnection.instance.lastMessage!
        let status = theResult["result"].stringValue
        let message = theResult["reason"].stringValue
        
        if status == "failure" {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.nameTextField.text = ""
            
        }
        else {
            self.performSegueWithIdentifier("showPlayers", sender: nil)
        }
        
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
