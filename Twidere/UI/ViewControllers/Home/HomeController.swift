//
//  HomeViewController.swift
//  Twidere
//
//  Created by Mariotaku Lee on 16/7/8.
//  Copyright © 2016年 Mariotaku Dev. All rights reserved.
//

import UIKit
import SDWebImage
import SugarRecord
import UIView_TouchHighlighting
import REFrostedViewController
import Pager
import PromiseKit
import SQLite

class HomeController: PagerController, PagerDataSource {
    
    @IBOutlet weak var accountProfileImageView: UIImageView!
    @IBOutlet weak var menuToggleItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        self.accountProfileImageView.layer.cornerRadius = self.accountProfileImageView.frame.size.width / 2
        self.accountProfileImageView.clipsToBounds = true
        
        menuToggleItem.customView?.touchHighlightingStyle = .TransparentMask
        
        let titles = ["Home timeline", "User timeline"]
        let homeTimelineController = StatusesListController(nibName: "StatusesListController", bundle: nil)
        homeTimelineController.delegate = HomeTimelineStatusesListControllerDelegate()
        let userTimelineController = StatusesListController(nibName: "StatusesListController", bundle: nil)
        userTimelineController.delegate = UserTimelineStatusesListControllerDelegate()
        let pages = [homeTimelineController, userTimelineController]
        
        setupPager(tabNames: titles, tabControllers: pages)
    }
    
    override func viewDidAppear(animated: Bool) {
        let account = try! defaultAccount()!
        accountProfileImageView.displayImage(account.user!.profileImageUrlForSize(.ReasonablySmall), placeholder: UIImage(named: "Profile Image Default"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func composeClicked(sender: UIBarButtonItem) {
        ComposeController.show(self, identifier: "Compose")
    }
    
    @IBAction func menuToggleClicked(sender: UITapGestureRecognizer) {
        frostedViewController.presentMenuViewController()
    }
    
    @IBAction func panGestureRecognized(sender: UIPanGestureRecognizer) {
        frostedViewController.panGestureRecognized(sender)
    }
    
    class HomeTimelineStatusesListControllerDelegate: StatusesListControllerDelegate {
        func loadStatuses(opts: StatusesListController.LoadOptions) -> Promise<[FlatStatus]> {
            return dispatch_promise {  () -> [FlatStatus] in
                let db = (UIApplication.sharedApplication().delegate as! AppDelegate).sqliteDatabase
                let table = Table("home_statuses")
                
                if let params = opts.params {
                    GetStatusesTask.execute(params, table: table) { account, microblog, paging -> [FlatStatus] in
                        return FlatStatus.arrayFromJson(try microblog.getHomeTimeline(paging), account: account)
                    }
                }
                return try db.prepare(table).map { row -> FlatStatus in
                    return FlatStatus(row: row)
                }
            }
        }
    }
    
    class UserTimelineStatusesListControllerDelegate: StatusesListControllerDelegate {
        func loadStatuses(opts: StatusesListController.LoadOptions) -> Promise<[FlatStatus]> {
            return dispatch_promise {  () -> [FlatStatus] in
                if (opts.initLoad) {
                    sleep(1)
                    return [FlatStatus]()
                }
                let account = try defaultAccount()!
                let microblog = account.newMicroblogInstance()
                return FlatStatus.arrayFromJson(try microblog.getUserTimeline(), account: account)
            }
        }
    }
    
}