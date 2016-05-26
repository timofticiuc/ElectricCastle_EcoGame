//
//  ECUserController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 06/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

let kUserNameIndex       = 0
let kUserPhoneIndex      = 1
let kUserRoleIndex       = 2
let kUserNewsletterIndex = 3
let kUserRemoveIndex     = 4
let kUserCategoriesIndex = 5


protocol ECUserControllerDelegate {
    func userController(uc:ECUserController, hasCreatedUser user:ECUser)
    func userController(uc:ECUserController, hasUpdatedUser user:ECUser)
    func userController(uc:ECUserController, hasDeletedUser user:ECUser)
}

class ECUserController: UITableViewController, ECCategoriesDelegate {
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var userPhoneField: UITextField!
    @IBOutlet var userRoleSegment: UISegmentedControl!
    @IBOutlet var userRemoveLabel: UILabel!

    private var isNewUser: Bool = false

    var delegate:ECUserControllerDelegate? = nil
    var user:ECUser! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

    func setupUI() {
        isNewUser = (self.user == nil)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.userRemoveLabel.layer.masksToBounds = true
        self.userRemoveLabel.layer.cornerRadius = 15.0
        
        if !isNewUser {
            self.userNameField.text = self.user.userName
            self.userPhoneField.text = self.user.userPhone
            self.userRoleSegment.selectedSegmentIndex = Int(self.user.userRole.rawValue)
        }
    }
    
    func doneEditing() {
        
        if delegate != nil {
            if (self.validatePhoneNumber(self.userPhoneField.text!) && (self.userNameField.text != "")) {
                if isNewUser {
                    let id = (ECCoreManager.sharedInstance.storeManager.managedObjectContext?.countForFetchRequest(ECUser.fetchRequestForUsers(), error: nil))!
                    self.user = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\(id)"], inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
                    self.user.userName = self.userNameField.text!
                    self.user.userPhone = self.userPhoneField.text!
                    self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
                    self.user.userCategories = self.user.defaultCategories()
                    
                    self.delegate?.userController(self, hasCreatedUser: self.user)
                    
                    // mark as dirty
                } else {
                    self.user.userName = self.userNameField.text!
                    self.user.userPhone = self.userPhoneField.text!
                    self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
                    self.delegate?.userController(self, hasUpdatedUser: self.user)
                }

            } else {
                let alertController = UIAlertController(title: "Alert", message: "Invalid data! Try again!", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Methods
    
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "[-+]?[0-9]+"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phonePredicate.evaluateWithObject(value)
        return result
    }

    func removeUser(alert: UIAlertAction!) {
        self.user.removeFromStore()
        self.delegate?.userController(self, hasDeletedUser: self.user)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.self .isKindOfClass(ECCategoriesController) {
            (segue.destinationViewController as! ECCategoriesController).user = self.user
            (segue.destinationViewController as! ECCategoriesController).delegate = self
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 6 {
            if let role = ECCoreManager.sharedInstance.currentUser?.userRole {
                switch role {
                case .ECUserRoleAdmin:
                    if indexPath.row == kUserRemoveIndex {
                        if self.isNewUser {
                            self.userRemoveLabel.hidden = true
                            return 0;
                        }
                    } else if indexPath.row == kUserCategoriesIndex {
                        if self.isNewUser {
                            return 0;
                        } else {
                            return 500;
                        }
                    }
                    return 70;
                case .ECUserRoleVolunteer:
                    if indexPath.row == kUserRoleIndex {
                        self.userRoleSegment.hidden = true
                        return 0;
                    } else if indexPath.row == kUserRemoveIndex {
                        if self.isNewUser {
                            self.userRemoveLabel.hidden = true
                            return 0;
                        } else if self.user.userRole != .ECUserRoleParticipant {
                            self.userRemoveLabel.hidden = true
                            return 0;
                        }
                    } else if indexPath.row == kUserCategoriesIndex {
                        if self.isNewUser {
                            return 0;
                        } else {
                            return 500;
                        }
                    }
                    return 70
                default:
                    self.userRoleSegment.hidden = true
                    self.userRemoveLabel.hidden = true
                    return 0;
                }
            }
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        if indexPath.row == kUserRemoveIndex {
            
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this user?", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "Yes", style: .Destructive, handler: removeUser)
            alertController.addAction(defaultAction)
            
            let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - ECCategoriesDelegate
    
    func categoriesController(cc: ECCategoriesController, hasSelectedCategory category: ECCategory) {
        let categoryVC: ECCategoryController = ECCategoryController.ec_createFromStoryboard() as! ECCategoryController
        categoryVC.category = category
        
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}
