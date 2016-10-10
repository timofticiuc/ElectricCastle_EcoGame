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

    var dataSource: ECUsersDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(catchFailedUserNotification), name: kFailedUserNotification, object: nil)
        
        self.dataSource = ECUsersDataSource.init(withDelegate: self, andTableView: self.tableView)
        self.configureView()
        self.setupProgressView()
        self.dataSource.fetchData()
        self.dataSource.reloadData()
        if self.dataSource.users.count == 0 {
            self.resetData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.toolBarHeightConstraint.constant = (ECCoreManager.sharedInstance.currentUser?.userRole == .ECUserRoleAdmin ? 220 : 50)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.dataSource.isReloading {
            self.dataSource.fetchData()
            self.dataSource.reloadData()
        }
    }
    
    func resetData() {
        if ECCoreManager.sharedInstance.reachabilityManager.isReachable() {
            self.resetFilters()
            self.dataSource.fetchRemoteData()
            self.view.bringSubviewToFront(self.overlayView)
            self.overlayView.hidden = false
            
            if self.progressView != nil {
                self.progressView.animateToAngle(0, duration: 0.25, completion: { (done) in })
            }
            
            UIView.animateWithDuration(0.25) {
                self.overlayView.alpha = 1
            }
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func cancelFetch() {
        self.dataSource.cancelFetchRemoteData()
    }
    
    func catchFailedUserNotification(notif: NSNotification) {
        let userVC = ECUserController.ec_createFromStoryboard() as! ECUserController
        userVC.user = notif.object as! ECUser
        userVC.errorMessage = notif.userInfo!["error"] as! String
        userVC.delegate = self.dataSource
        self.navigationController?.pushViewController(userVC, animated: true)
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
    
    @IBAction func showStats() {
        let statsVC = ECStatsController.ec_createFromStoryboard() as! ECStatsController
        statsVC.users = self.dataSource.unfilteredUsers()
        self.navigationController?.pushViewController(statsVC, animated: true)
    }
    
    @IBAction func deleteAll() {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you wish to delete all participants both locally and remote?", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) in
            self.dataSource.removeAllUsersOfType(.ECUserRoleParticipant) { (success) in
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)

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
    
    func dataSource(ds: ECUsersDataSource, hasFinishedFetchingData wasCanceled: Bool) {
        if !wasCanceled {
            self.resetFilters()
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
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshControl.endRefreshing()
                UIView.animateWithDuration(0.25, animations: {
                    self.overlayView.alpha = 0
                    }, completion: { (done) in
                        self.overlayView.hidden = true
                })
            })
        }
    }
    
    // MARK: ECSearchDelegate
    
    func searchView(searchView: ECSearchHeaderView, didChangeQueryWithText query: String) {
        self.dataSource.fetchData()
        self.dataSource?.fetchWithQuery(query)
    }
    
    //MARK: - ECSortDelegate
    
    func sortController(sc: ECSortController, hasSelectedCategory category: ECConstants.Category, withSortAsAscending ascending: Bool, actionIndex: Int) {
        self.dataSource.applyCategorySort(category, ascending: ascending, actionIndex: actionIndex)
        let title = "Sort: " + category.ec_enumName() + (ascending ? ", ascending" : ", descending")
        self.userSortButton.setTitle(title, forState: .Normal)
        self.dataSource.fetchData()
        self.dataSource.reloadData()
    }
    
    //MARK: - Reset
    
    @IBAction func resetFilters() {
        self.userSortButton.setTitle("Sort: None", forState: .Normal)
        self.dataSource.applyCategorySort(ECConstants.Category.None, ascending: false, actionIndex: 0)
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
        // add address, creation date, total score
        var csv = ",,,,,,ENERGY,,,WASTE,,,,WATER,,,TRANSPORT,,,,,SOCIAL,,,,\n"
        csv += "FIRST NAME,LAST NAME,PHONE,MAIL,ADDRESS,CREATION DATE,Play the Pedals Battle,Calculate your carbon footprint,Watch a video about energy at the ECO Cinema,Collect 30 waste packages,Collect 20 waste packages,Collect 10 waste packages,Waste video,Take 5 minutes showers,Shower in two,Watch a video about water at the ECO Cinema,Come to the festival by bicycle,By train,4 in a car,By bus,Transport Video,Play the Gas Twist,Music Drives Change,ECO Quiz,Social video,TOTAL SCORE\n"
        for user in self.dataSource.users {
            var totalScore = 0
            csv += user.userLastName + "," + user.userFirstName + "," + user.userPhone + "," + user.userEmail + "," + user.userAddress.stringByReplacingOccurrencesOfString(",", withString: "") + "," + String(user.createdAt)
            for categ in user.userCategories {
                for i in 0...categ.actions().count - 1 {
                    let score = categ.categoryScores[i].score * categ.actions()[i][kMultiplier]!.integerValue
                    csv += "," + String(score)
                    totalScore += score
                    
                    switch categ.categoryType {
                    case .Energy:
                        if i == 1 {
                            let metaData = categ.categoryScores[i].metadata
                            if metaData.characters.count != 0 {
                                csv += " (" + metaData + ")"
                            }
                        }
                        break
                    case .Transport:
                        if i > 0 && i < categ.categoryScores.count - 1 {
                            let metaData = categ.categoryScores[i].metadata
                            if metaData.characters.count != 0 {
                                csv += " (" + metaData + " km)"
                            }
                        }
                        break
                        
                    default:
                        break
                    }
                }
            }
            csv += "," + String(totalScore)
            csv += "\n"
        }
        NSLog("%@", csv)
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["contact@mainoi.ro"])
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
        if error != nil {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: error!.localizedDescription, delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }
}

