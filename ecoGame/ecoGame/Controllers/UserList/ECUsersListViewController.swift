//
//  DetailViewController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 28/03/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECUsersListViewController: UIViewController, ECUsersDataSourceDelegate, ECSearchDelegate, ECSortDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    @IBOutlet weak var userSortButton: UIButton!
    @IBOutlet weak var toolBarHeightConstraint: NSLayoutConstraint!

    private var _searchView: ECSearchHeaderView!
    private var searchView: ECSearchHeaderView! {
        get {
            if _searchView == nil {
                _searchView = ECSearchHeaderView.ec_loadFromNib()
                _searchView.delegate = self
            }
            return _searchView
        }
    }

    private var dataSource: ECUsersDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.dataSource = ECUsersDataSource.init(withDelegate: self, andTableView: self.tableView)
        self.configureView()
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toolBarHeightConstraint.constant = (ECCoreManager.sharedInstance.currentUser?.userRole == .ECUserRoleAdmin ? 100 : 50)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataSource?.fetchData()
    }

    func configureView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self.dataSource, action: #selector(ECUsersDataSource.addUser))
        self.navigationItem.rightBarButtonItem = addButton
        self.searchContainerView.ec_addSubView(self.searchView, withInsets: UIEdgeInsetsZero)
        self.userSegmentControl.selectedSegmentIndex = 3
        self.userSortButton.layer.cornerRadius = 5
        self.userSortButton.layer.borderColor = UIColor.ec_greenFaded().CGColor
        self.userSortButton.layer.borderWidth = 1
        self.userSortButton.setTitle("Sort: --", forState: .Normal)
    }
    
    @IBAction func userRoleSegmentDidChangeValue(segmentControl: UISegmentedControl) {
        self.dataSource?.applyUserFilter(ECUserRole(rawValue: Int32(segmentControl.selectedSegmentIndex))!)
    }
    
    @IBAction func sortAction() {
        let sortController = ECSortController.ec_createFromStoryboard() as! ECSortController
        sortController.delegate = self
        
        sortController.modalPresentationStyle = .FormSheet
        self.presentViewController(sortController, animated: true, completion: nil)
    }
    
    // MARK: ECUserListDataSourceDelegate
    
    func dataSource(ds: ECUsersDataSource, wantsToShowViewController vc: UIViewController) {        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: ECSearchDelegate
    
    func searchView(searchView: ECSearchHeaderView, didChangeQueryWithText query: String) {
        self.dataSource?.fetchWithQuery(query)
    }
    
    //MARK: - ECSortDelegate
    
    func sortController(sc: ECSortController, hasSelectedCategory category: ECConstants.Category, withSortAsAscending ascending: Bool) {
        self.dataSource?.applyCategorySort(category, ascending: ascending)
        let title = "Sort: " + category.ec_enumName() + (ascending ? ", ascending" : ", descending")
        self.userSortButton.setTitle(title, forState: .Normal)
    }
}

