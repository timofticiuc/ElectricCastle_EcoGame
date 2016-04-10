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
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI() {
        let cornerRadius: CGFloat = 15.0
        let borderWidth: CGFloat = 1.0
        
        self.userNameField.layer.cornerRadius = cornerRadius
        self.userPasswordField.layer.cornerRadius = cornerRadius
        self.loginButton.layer.cornerRadius = cornerRadius

        self.userNameField.layer.borderWidth = borderWidth
        self.userPasswordField.layer.borderWidth = borderWidth
        self.loginButton.layer.borderWidth = borderWidth
        
        self.userNameField.layer.borderColor = UIColor.ec_green().CGColor
        self.userPasswordField.layer.borderColor = UIColor.ec_green().CGColor
        self.loginButton.layer.borderColor = UIColor.ec_gray().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction() {
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
