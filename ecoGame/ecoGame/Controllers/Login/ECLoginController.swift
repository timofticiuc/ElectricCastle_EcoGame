//
//  ECLoginController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 10/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECLoginController: UITableViewController {
    
    let sectionsCount = 4
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userNameField.attributedPlaceholder = NSAttributedString(string: "phone/email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.userPasswordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction() {
        ECCoreManager.sharedInstance.loginWithCredentials(self.userNameField.text!, andPasswordHash: self.userPasswordField.text!) { (user) in
            if user == nil {
                let alertController = UIAlertController(title: "Alert", message: "Login failed", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .Destructive, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                ECCoreManager.sharedInstance.currentUser = user
                ECCoreManager.sharedInstance.currentSessionTimeStamp = NSDate()
                ECCoreManager.sharedInstance.storeManager.saveContext()
                
                self.dismissViewControllerAnimated(true) {}
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsCount
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}
