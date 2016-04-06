//
//  ECUserController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 06/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECUserControllerDelegate {
    func userController(uc:ECUserController, hasCreatedUser user:ECUser)
    func userController(uc:ECUserController, hasUpdatedUser user:ECUser)
    func userController(uc:ECUserController, hasDeletedUser user:ECUser)
}

class ECUserController: UITableViewController {
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var userPhoneField: UITextField!
    @IBOutlet var userRoleSegment: UISegmentedControl!

    private var isNewUser: Bool = false

    var delegate:ECUserControllerDelegate? = nil
    var user:ECUser! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }

    func configureView() {
        isNewUser = (self.user == nil)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = addButton
        
        if !isNewUser {
            self.userNameField.text = self.user.userName
            self.userPhoneField.text = self.user.userPhone
            self.userRoleSegment.selectedSegmentIndex = Int(self.user.userRole.rawValue)
        }
    }
    
    func doneEditing() {
        if delegate != nil {
            if isNewUser {
                let id = (ECCoreManager.sharedInstance.storeManager.managedObjectContext?.countForFetchRequest(ECUser.fetchRequestForUsers(), error: nil))!
                self.user = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\(id)"],
                                                                              inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
                self.user.createdAt = NSDate()
                self.user.userName = self.userNameField.text!
                self.user.userPhone = self.userPhoneField.text!
                self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
                
                self.delegate?.userController(self, hasCreatedUser: self.user)
            } else {
                self.user.userName = self.userNameField.text!
                self.user.userPhone = self.userPhoneField.text!
                self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
                self.delegate?.userController(self, hasUpdatedUser: self.user)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
