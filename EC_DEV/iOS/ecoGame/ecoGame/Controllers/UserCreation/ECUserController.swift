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
            if isNewUser {
                let id = (ECCoreManager.sharedInstance.storeManager.managedObjectContext?.countForFetchRequest(ECUser.fetchRequestForUsers(), error: nil))!
                self.user = ECUser.objectCreatedOrUpdatedWithDictionary(["id":"\(id)"], inContext:ECCoreManager.sharedInstance.storeManager.managedObjectContext!) as! ECUser
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
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 4 {
            if let role = ECCoreManager.sharedInstance.currentUser?.userRole {
                switch role {
                case .ECUserRoleAdmin:
                    if indexPath.row == 3 {
                        if self.isNewUser {
                            self.userRemoveLabel.hidden = true
                            return 0;
                        }
                    }
                    return 70;
                case .ECUserRoleVolunteer:
                    if indexPath.row == 2 {
                        self.userRoleSegment.hidden = true
                        return 0;
                    } else if indexPath.row == 3 {
                        if self.isNewUser {
                            self.userRemoveLabel.hidden = true
                            return 0;
                        } else if self.user.userRole != .ECUserRoleParticipant {
                            self.userRemoveLabel.hidden = true
                            return 0;
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
        
        if indexPath.row == 3 {
            self.user.removeFromStore()
            self.delegate?.userController(self, hasDeletedUser: self.user)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
