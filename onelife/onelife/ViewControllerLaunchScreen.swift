//
//  LaunchScreenViewController.swift
//  onelife
//
//  Created by Andy Bartlett on 19/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit

class ViewControllerLaunchScreen: UIViewController {

    let group = dispatch_group_create()
    

    @IBOutlet weak var accountNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        OLRestServerConnection.instance.Get("http://localhost:5000/data/monsters.json")
        OLMonsters.instance.monsters = OLRestServerConnection.instance.lastMessage
        OLRestServerConnection.instance.Get("http://localhost:5000/data/playerTypes.json")
        OLPlayerTypes.instance.playerTypes = OLRestServerConnection.instance.lastMessage
    
        self.accountNameText.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        let name = accountNameText.text
        let password = passwordText.text
        let cred: [String:AnyObject] = [
            "name":name!,
            "password":password!
        ]
        OLRestServerConnection.instance.Post("http://localhost:5000/login", json: cred)
        
        let theResult = OLRestServerConnection.instance.lastMessage!
        let status = theResult["result"].stringValue
        let message = theResult["reason"].stringValue
        
        if status == "failure" {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.accountNameText.text = ""
            self.passwordText.text = ""
            
            self.accountNameText.becomeFirstResponder()
            
        }
        else {
            print(theResult)
            OLAccount.instance.set(theResult)
            OLAccount.instance.loggedIn = true
            self.performSegueWithIdentifier("showPlayers", sender: nil)
        }
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
