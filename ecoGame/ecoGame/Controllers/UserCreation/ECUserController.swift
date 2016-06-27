//
//  ECUserController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 06/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

let kUserFirstNameIndex  = 0
let kUserLastNameIndex   = 1
let kUserPhoneIndex      = 2
let kUserAddressIndex    = 3
let kUserEmailIndex      = 4
let kUserPasswordIndex   = 5
let kUserRoleIndex       = 6
let kUserNewsletterIndex = 7
let kUserRemoveIndex     = 8
let kUserCategoriesIndex = 9

protocol ECUserControllerDelegate {
    func userController(uc:ECUserController, hasCreatedUser user:ECUser)
    func userController(uc:ECUserController, hasUpdatedUser user:ECUser)
    func userController(uc:ECUserController, hasDeletedUser user:ECUser)
}

class ECUserController: UITableViewController, ECCategoriesDelegate, ECAgreementDelegate, UITextFieldDelegate {
    @IBOutlet var userFirstNameField: UITextField!
    @IBOutlet var userLastNameField: UITextField!
    @IBOutlet var userPhoneField: UITextField!
    @IBOutlet var userAddressField: UITextField!
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userPasswordField: UITextField!
    @IBOutlet var userRoleSegment: UISegmentedControl!
    @IBOutlet var userRemoveLabel: UILabel!

    private var categoriesCollectionController: ECCategoriesController!
    private var isNewUser: Bool = false
    private var hasChangedPassword:Bool = false

    var delegate:ECUserControllerDelegate? = nil
    var user:ECUser! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.self .isKindOfClass(ECCategoriesController) {
            self.categoriesCollectionController = segue.destinationViewController as! ECCategoriesController
            self.categoriesCollectionController.user = self.user
            self.categoriesCollectionController.delegate = self
        }
    }

    func setupUI() {
        isNewUser = (self.user == nil)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneEditing))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.userRemoveLabel.layer.masksToBounds = true
        self.userRemoveLabel.layer.cornerRadius = 15.0
        
        if !isNewUser {
            self.userFirstNameField.text = self.user.userFirstName
            self.userLastNameField.text = self.user.userLastName
            self.userPhoneField.text = self.user.userPhone
            self.userAddressField.text = self.user.userAddress
            self.userEmailField.text = self.user.userEmail
            self.userPasswordField.text = self.user.userPasswordHash
            self.userRoleSegment.selectedSegmentIndex = Int(self.user.userRole.rawValue)
            
            for category in self.user.userCategories {
                ECCoreManager.sharedInstance.getCategoryForId(category.id, withCompletion: { (category) in
                    ECCoreManager.sharedInstance.storeManager.saveContext()
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.categoriesCollectionController.collectionView?.reloadData()
                    })
                })
            }
        }
    }
    
    func doneEditing() {
        if delegate != nil {
            if (self.validatePhoneNumber(self.userPhoneField.text!) && (self.userFirstNameField.text != "") && (self.userLastNameField.text != "")) {
                if isNewUser {
                    let ac:ECAgreementController = ECAgreementController.ec_createFromStoryboard() as! ECAgreementController
                    ac.delegate = self
                    
                    self.presentViewController(ac, animated: true) {
                        
                    }
                } else {
                    self.updateUser()
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
    
    private func createUser() {
        var id = (ECCoreManager.sharedInstance.storeManager.managedObjectContext?.countForFetchRequest(ECUser.fetchRequestForUsers(), error: nil))!
        id += Int(arc4random()%32767)
        self.user = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\(id)"], inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
        self.user.userFirstName = self.userFirstNameField.text!
        self.user.userLastName = self.userLastNameField.text!
        self.user.userPhone = self.userPhoneField.text!
        self.user.userAddress = self.userAddressField.text!
        self.user.userEmail = self.userEmailField.text!
        self.user.userPasswordHash = String(self.userPasswordField.text!.hash)
        self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
        self.user.userCategories = self.user.defaultCategories()
        
        self.delegate?.userController(self, hasCreatedUser: self.user)
    }
    
    private func updateUser() {
        self.user.userFirstName = self.userFirstNameField.text!
        self.user.userLastName = self.userLastNameField.text!
        self.user.userPhone = self.userPhoneField.text!
        self.user.userAddress = self.userAddressField.text!
        self.user.userEmail = self.userEmailField.text!
        self.user.userPasswordHash = (self.hasChangedPassword ? String(self.userPasswordField.text!.hash) : self.userPasswordField.text!)
        self.user.userRole = ECUserRole(rawValue:Int32(self.userRoleSegment.selectedSegmentIndex))!
        self.delegate?.userController(self, hasUpdatedUser: self.user)
    }
    
    func removeUser(alert: UIAlertAction!) {
        self.delegate?.userController(self, hasDeletedUser: self.user)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.hasChangedPassword = true

        return true
    }
    
    // MARK: - Helper Methods
    
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "[-+]?[0-9]+"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phonePredicate.evaluateWithObject(value)
        return result
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 10 {
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
                            return 600;
                        }
                    }
                    return 70;
                case .ECUserRoleVolunteer:
                    if indexPath.row == kUserRoleIndex {
                        self.userRoleSegment.hidden = true
                        return 0;
                    } else if indexPath.row == kUserRemoveIndex {
                        self.userRemoveLabel.hidden = true
                        return 0;
                    } else if indexPath.row == kUserCategoriesIndex {
                        if self.isNewUser {
                            return 0;
                        } else {
                            return 600;
                        }
                    } else if indexPath.row == kUserPasswordIndex {
                        self.userPasswordField.hidden = true
                        return 0;
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
        categoryVC.user = self.user
        
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK: - ECAgreementDelegate
    
    func agreementController(ac: ECAgreementController, hasCompletedWithSelectedTerms selectedTerms:Bool) {
        self.createUser()
    }
}
