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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction() {
        let dummyUser:ECUser = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\(arc4random()%32767)"], inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
        let userNames = self.userNameField.text?.componentsSeparatedByString(" ")
        dummyUser.userFirstName = (userNames?.count > 0 ? userNames![0] : "")
        dummyUser.userLastName  = (userNames?.count > 1 ? userNames![1] : "")
        dummyUser.userPhone = "0000000000"
        dummyUser.userAddress = "Default address"
        dummyUser.userPasswordHash = String(self.userPasswordField.text?.hash)
        dummyUser.userRole = .ECUserRoleAdmin
        dummyUser.userCategories = dummyUser.defaultCategories()
        
        ECCoreManager.sharedInstance.currentUser = dummyUser
        ECCoreManager.sharedInstance.currentSessionTimeStamp = NSDate()
        ECCoreManager.sharedInstance.storeManager.saveContext()

        self.dismissViewControllerAnimated(true) {
            
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
