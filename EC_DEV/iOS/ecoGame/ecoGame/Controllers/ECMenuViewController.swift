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
        
        self.userNameLabel.text = ECCoreManager.sharedInstance.currentUser?.userName
        self.userRoleLabel.text = ECCoreManager.sharedInstance.currentUser?.userRole.ec_enumName()
        self.userSessionLabel.text = "Online for: " + String(NSDate().hoursFrom(ECCoreManager.sharedInstance.currentSessionTimeStamp)) + "h " + String(NSDate().minutesFrom(ECCoreManager.sharedInstance.currentSessionTimeStamp)) + "m"
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 50
        case 2:
            return 50
        case 3:
            return 50
        case 4:
            return 70
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}

