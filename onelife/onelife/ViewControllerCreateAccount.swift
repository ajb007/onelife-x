//
//  NewAccountViewController.swift
//  onelife
//
//  Created by Andy Bartlett on 19/03/2016.
//  Copyright © 2016 Andy Bartlett. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class ViewControllerCreateAccount: UIViewController {

    @IBOutlet weak var textAccountName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textAccountName.becomeFirstResponder()
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
    @IBAction func buttonCreate(sender: AnyObject) {
        
        OLAccount.instance.name = textAccountName.text
        OLAccount.instance.password = textPassword.text
        OLAccount.instance.email = textEmail.text
        
        let json = OLAccount.instance.json()
    
        
        OLRestServerConnection.instance.Post("http://localhost:5000/create_account", json: json as [String:AnyObject])
            
        let theResult = OLRestServerConnection.instance.lastMessage!    
        let status = theResult["result"].stringValue
        let message = theResult["reason"].stringValue
        
        if status == "failure" {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.textPassword.text = ""
            self.textEmail.text = ""
            self.textAccountName.text = ""
            
            self.textAccountName.becomeFirstResponder()
            
        }
        else {
            OLAccount.instance.loggedIn = true
            OLAccount.instance.id = theResult["id"].intValue
            self.performSegueWithIdentifier("newAccountCreated", sender: nil)

        }
        
        
    }

}
