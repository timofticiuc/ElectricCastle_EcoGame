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
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
//    @IBOutlet weak var userSortButton: UIButton!
    @IBOutlet weak var toolBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    private var refreshControl: UIRefreshControl!
    private var progressView:KDCircularProgress!
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
        self.setupProgressView()
        self.dataSource.fetchData()
        self.dataSource.reloadData()
        self.resetData()
    }
    
    func resetData() {
        //        if self.dataSource.users.count == 0 {
        //            self.dataSource.fetchRemoteData()
        //            self.view.bringSubviewToFront(self.overlayView)
        //            UIView.animateWithDuration(0.25) {
        //                self.overlayView.alpha = 1
        //            }
        //        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.toolBarHeightConstraint.constant = (ECCoreManager.sharedInstance.currentUser?.userRole == .ECUserRoleAdmin ? 150 : 50)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    func setupProgressView() {
        if progressView != nil {
            return
        }
        progressView = KDCircularProgress(frame: self.progressContainerView.bounds)
        progressView.startAngle = -90
        progressView.clockwise = true
        progressView.center = self.progressContainerView.center
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = true
        progressView.glowMode = .Forward
        progressView.setColors(UIColor.ec_green())
        progressView.trackColor = UIColor ( red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0 )
        progressView.trackThickness = 0.2
        progressView.progressThickness = 0.2
        self.progressContainerView.ec_addSubView(progressView, withInsets: UIEdgeInsetsZero)
        self.progressView.frame = self.progressContainerView.bounds
    }

    func configureView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self.dataSource, action: #selector(ECUsersDataSource.addUser))
        self.navigationItem.rightBarButtonItem = addButton
        self.searchContainerView.ec_addSubView(self.searchView, withInsets: UIEdgeInsetsZero)
        self.userSegmentControl.selectedSegmentIndex = 3
        self.categorySegmentControl.selectedSegmentIndex = 5
        self.userSegmentControl.addTarget(self, action: #selector(userRoleChanged), forControlEvents: .ValueChanged)
        self.categorySegmentControl.addTarget(self, action: #selector(categoryChanged), forControlEvents: .ValueChanged)

//        self.userSortButton.layer.cornerRadius = 5
//        self.userSortButton.layer.borderColor = UIColor.ec_greenFaded().CGColor
//        self.userSortButton.layer.borderWidth = 1
//        self.userSortButton.setTitle("Sort: --", forState: .Normal)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.ec_green()
        self.refreshControl.addTarget(self, action: #selector(resetData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func userRoleChanged(segmentControl: UISegmentedControl) {
        self.dataSource?.applyUserFilter(ECUserRole(rawValue: Int32(segmentControl.selectedSegmentIndex))!)
    }
    
    func categoryChanged(segmentControl: UISegmentedControl) {
        var categType = ECConstants.Category(rawValue: Int32(segmentControl.selectedSegmentIndex))!
        if segmentControl.selectedSegmentIndex == 5 {
            categType = ECConstants.Category.None
        }
        self.dataSource?.applyCategoryFilter(categType)
    }
    
    @IBAction func sortAction() {
        let sortController = ECSortController.ec_createFromStoryboard() as! ECSortController
        sortController.delegate = self
        
        sortController.modalPresentationStyle = .FormSheet
        self.presentViewController(sortController, animated: true, completion: nil)
    }
    
    @IBAction func sortByMusicDrive() {
        self.dataSource.musicDrive = !self.dataSource.musicDrive
    }
    
    @IBAction func getRandomUser() {
        self.dataSource.random = true
    }
    
    // MARK: ECUserListDataSourceDelegate
    
    func dataSource(ds: ECUsersDataSource, wantsToShowViewController vc: UIViewController) {        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dataSource(ds: ECUsersDataSource, hasChangedUserProgress userProgress: Int, count: Int) {
//        let progressString = "Fetching user: " + String(userProgress) + "/" + String(count)
//        NSLog(progressString)
    }
    
    func dataSource(ds: ECUsersDataSource, hasChangedCategoryProgress categoryProgress: Int, count: Int) {
        var progressString = "Fetching category: " + String(categoryProgress) + "/" + String(count)
//        NSLog(progressString)
        progressString = "Fetching user: " + String(categoryProgress) + "/" + String(count)

        dispatch_async(dispatch_get_main_queue(), {
            
            self.progressLabel.text = progressString
            let progress = Double(categoryProgress)/Double(count)
            let angle: Double = progress * 360
            
            if self.progressView != nil {
                self.progressView.animateToAngle(angle, duration: 0.25, completion: { (done) in
                    
                })
            }
            
            if categoryProgress == count {
                self.refreshControl.endRefreshing()
                UIView.animateWithDuration(0.25, animations: {
                    self.overlayView.alpha = 0
                    }, completion: { (done) in
                        self.overlayView.hidden = true
                })
            }
        })
    }
    
    // MARK: ECSearchDelegate
    
    func searchView(searchView: ECSearchHeaderView, didChangeQueryWithText query: String) {
        self.dataSource?.fetchWithQuery(query)
    }
    
    //MARK: - ECSortDelegate
    
    func sortController(sc: ECSortController, hasSelectedCategory category: ECConstants.Category, withSortAsAscending ascending: Bool) {
        self.dataSource?.applyCategorySort(category, ascending: ascending)
        let title = "Sort: " + category.ec_enumName() + (ascending ? ", ascending" : ", descending")
//        self.userSortButton.setTitle(title, forState: .Normal)
    }
}

