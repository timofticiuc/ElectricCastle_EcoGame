//
//  DetailViewController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 28/03/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUsersListViewController: UIViewController {

    private var users = [AnyObject]()
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ECUsersListViewController.addNewUser(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    func addNewUser(user: AnyObject?) -> Void {
        guard let _ = user
            else { return }
        
        self.users.append(user!)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
}

