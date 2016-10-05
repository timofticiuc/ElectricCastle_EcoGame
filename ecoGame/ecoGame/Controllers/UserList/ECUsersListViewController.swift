//
//  DetailViewController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 28/03/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import MessageUI

class ECUsersListViewController: UIViewController, ECUsersDataSourceDelegate, ECSearchDelegate, ECSortDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var userSortButton: UIButton!
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
        if self.dataSource.users.count == 0 {
            self.resetData()
        }
    }
    
    func resetData() {
        self.resetFilters()
        self.dataSource.fetchRemoteData()
        self.view.bringSubviewToFront(self.overlayView)
        self.overlayView.hidden = false
        UIView.animateWithDuration(0.25) {
            self.overlayView.alpha = 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.toolBarHeightConstraint.constant = (ECCoreManager.sharedInstance.currentUser?.userRole == .ECUserRoleAdmin ? 170 : 50)
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
        self.userSortButton.setTitle("Sort: None", forState: .Normal)        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.ec_green()
        self.refreshControl.addTarget(self, action: #selector(resetData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func userRoleChanged(segmentControl: UISegmentedControl) {
        self.dataSource.applyUserFilter(ECUserRole(rawValue: Int32(segmentControl.selectedSegmentIndex))!)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    func categoryChanged(segmentControl: UISegmentedControl) {
        var categType = ECConstants.Category(rawValue: Int32(segmentControl.selectedSegmentIndex))!
        if segmentControl.selectedSegmentIndex == 5 {
            categType = ECConstants.Category.None
        }
        self.dataSource.applyCategoryFilter(categType)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    @IBAction func sortAction() {
        let sortController = ECSortController.ec_createFromStoryboard() as! ECSortController
        sortController.delegate = self
        
        sortController.modalPresentationStyle = .FormSheet
        self.presentViewController(sortController, animated: true, completion: nil)
    }
    
    @IBAction func sortByMusicDrive() {
        self.dataSource.musicDrive = !self.dataSource.musicDrive
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    @IBAction func getRandomUser() {
        self.dataSource.random = true
    }
    
    // MARK: ECUserListDataSourceDelegate
    
    func dataSource(ds: ECUsersDataSource, wantsToShowViewController vc: UIViewController) {        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dataSource(ds: ECUsersDataSource, hasChangedUserProgress userProgress: Int, count: Int) {
        
    }
    
    func dataSource(ds: ECUsersDataSource, hasChangedCategoryProgress categoryProgress: Int, count: Int) {
        let progressString = "Fetching user: \n" + String(categoryProgress) + "/" + String(count)

        dispatch_async(dispatch_get_main_queue(), {
            
            self.progressLabel.text = progressString
            let progress = Double(categoryProgress)/Double(count)
            let angle: Double = progress * 360
            
            if self.progressView != nil {
                self.progressView.animateToAngle(angle, duration: 0.25, completion: { (done) in
                    
                })
            }
        })
    }
    
    func dataSource(ds: ECUsersDataSource, hasFinishedFetchingData success: Bool) {
        self.dataSource.optimizeUsersDataWithCompletion({ (success) in
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshControl.endRefreshing()
                UIView.animateWithDuration(0.25, animations: {
                    self.overlayView.alpha = 0
                    }, completion: { (done) in
                        self.overlayView.hidden = true
                })
            })
            }, progressBlock: { (progress, count) in
                dispatch_async(dispatch_get_main_queue(), {
                    let optProgress = Double(progress)/Double(count)
                    let angle: Double = optProgress * 360
                    self.progressLabel.text = "Optimizing data\n " + String(format:"%.f", optProgress * 100) + "%"
                    
                    if self.progressView != nil {
                        self.progressView.animateToAngle(angle, duration: 0.25, completion: { (done) in
                            
                        })
                    }
                })
        })
    }
    
    // MARK: ECSearchDelegate
    
    func searchView(searchView: ECSearchHeaderView, didChangeQueryWithText query: String) {
        self.dataSource?.fetchWithQuery(query)
    }
    
    //MARK: - ECSortDelegate
    
    func sortController(sc: ECSortController, hasSelectedCategory category: ECConstants.Category, withSortAsAscending ascending: Bool) {
        self.dataSource.applyCategorySort(category, ascending: ascending)
        let title = "Sort: " + category.ec_enumName() + (ascending ? ", ascending" : ", descending")
        self.userSortButton.setTitle(title, forState: .Normal)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    //MARK: - Reset
    
    @IBAction func resetFilters() {
        self.userSortButton.setTitle("Sort: None", forState: .Normal)
        self.dataSource.applyCategorySort(ECConstants.Category.None, ascending: false)
        self.dataSource.musicDrive = false
        self.userSegmentControl.selectedSegmentIndex = 3
        self.categorySegmentControl.selectedSegmentIndex = 5
        self.dataSource.applyUserFilter(ECUserRole.ECUserRoleNone)
        self.dataSource.applyCategoryFilter(ECConstants.Category.None)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    //MARK: - CSV Export with mail
    
    @IBAction func composeMailWithCSV() {
        var csv = ",,,,ENERGY,,,WASTE,,,,WATER,,,TRANSPORT,,,,,SOCIAL,,,,\n"
        csv += "NUME,PRENUME,PHONE,MAIL,Play the Pedals Battle,Calculate your carbon footprint,Watch a video about energy at the ECO Cinema,Collect 30 waste packages,Collect 20 waste packages,Collect 10 waste packages,Waste video,Take 5 minutes showers,Shower in two,Watch a video about water at the ECO Cinema,Come to the festival by bicycle,By train,4 in a car,By bus,Transport Video,Play the Gas Twist,Music Drives Change,ECO Quiz,Social video\n"
        for user in self.dataSource.users {
            csv += user.userLastName + "," + user.userFirstName + "," + user.userPhone + "," + user.userEmail
            for categ in user.userCategories {
                for i in 0...categ.actions().count - 1 {
                    csv += "," + String(categ.categoryScores[i].score * categ.actions()[i][kMultiplier]!.integerValue)
                }
            }
            csv += "\n"
        }
        NSLog("%@", csv)
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["an3119151@yahoo.com"])
        mailComposerVC.setSubject("Export users")
        guard let data = csv.dataUsingEncoding(NSUTF8StringEncoding) else { return }
        mailComposerVC.addAttachmentData(data, mimeType: "text/csv", fileName: "users.csv")
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

