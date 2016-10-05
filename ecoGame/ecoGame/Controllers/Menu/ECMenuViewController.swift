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
        
        if ECCoreManager.sharedInstance.currentUser == nil {
            return
        }
        
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
    
    @IBAction func showStatsAction() {
        let splitViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! UISplitViewController
        let detailNavC = splitViewController.viewControllers.last as! UINavigationController
        let userListVC = detailNavC.viewControllers.first as! ECUsersListViewController
        let statsVC = ECStatsController.ec_createFromStoryboard() as! ECStatsController
        statsVC.users = userListVC.dataSource.users
        detailNavC.pushViewController(statsVC, animated: true)
        splitViewController.preferredDisplayMode = .PrimaryHidden
    }
    
    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 1:
            return 100
        case 2:
            return 44
        case 3:
            return 44
        case 4:
            return (ECCoreManager.sharedInstance.currentUser?.userRole == ECUserRole.ECUserRoleAdmin ? 44 : 0)
        case 5:
            return 60
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}

