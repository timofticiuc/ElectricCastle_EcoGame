//
//  DetailViewController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 28/03/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUsersListViewController: UIViewController, ECUsersDataSourceDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    private var dataSource: ECUsersDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.dataSource = ECUsersDataSource.init(withDelegate: self, andTableView: self.tableView)
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataSource?.fetchData()
    }

    func configureView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self.dataSource, action: #selector(ECUsersDataSource.addUser))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: ECUserListDataSourceDelegate
    
    func dataSource(ds: ECUsersDataSource, wantsToShowViewController vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

