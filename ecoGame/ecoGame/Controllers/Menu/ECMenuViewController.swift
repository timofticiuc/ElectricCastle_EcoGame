//
//  MasterViewController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 28/03/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECMenuViewController: UITableViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
    @IBOutlet weak var userSessionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userNameLabel.text = (ECCoreManager.sharedInstance.currentUser?.userFirstName)! + " " + (ECCoreManager.sharedInstance.currentUser?.userLastName)!
        self.userRoleLabel.text = ECCoreManager.sharedInstance.currentUser?.userRole.ec_enumName()
        self.userSessionLabel.text = "Online for: " + String(NSDate().offsetFrom(ECCoreManager.sharedInstance.currentSessionTimeStamp))
    }

    @IBAction func logoutAction() {
        ECCoreManager.sharedInstance.currentUser = nil
        let splitViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! UISplitViewController
        splitViewController.presentViewController(ECLoginController.ec_createFromStoryboard(), animated: true, completion: {
            
        });
    }
    
    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}

