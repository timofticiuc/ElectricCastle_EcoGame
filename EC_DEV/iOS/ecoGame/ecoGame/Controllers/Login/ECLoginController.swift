//
//  ECLoginController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 10/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECLoginController: UITableViewController {
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
        dummyUser.userName = self.userNameField.text!
        dummyUser.userPhone = "0000000000"
        dummyUser.userRole = .ECUserRoleAdmin
        
        ECCoreManager.sharedInstance.currentUser = dummyUser

        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}
