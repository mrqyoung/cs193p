//
//  DailyTableViewController.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/20.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit
import QuartzCore

class DailyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDaily(nil)

        //self.tableView.estimatedRowHeight = self.tableView.rowHeight
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSection = self.pages.count - 1
        if indexPath.section == lastSection && indexPath.row == self.tableView.numberOfRowsInSection(lastSection) - 1 {
            fetchDaily(self.lastDate)
        }
        
        let frame0 = cell.contentView.frame
        let frame1 = UIEdgeInsetsInsetRect(frame0, UIEdgeInsetsMake(4, 8, 4, 8))
        cell.contentView.frame = frame1
    }
    
    
    
    var pages = [Page]() { // a page contains list of stories
        didSet { self.tableView.reloadData() }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.pages.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.pages[section].news!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.pages[section].display_date
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    private let cellId = "storyCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
        let story = self.pages[indexPath.section].news![indexPath.row]
        if let storyCell = cell as? StoryTableViewCell {
            storyCell.story = story
            if let thumb = thumbImageCache[story.id!] {
                storyCell.thumbImage = thumb
            } else {
                storyCell.getTheImage {
                    if $0 != nil { self.thumbImageCache[story.id!] = $0 }
                }
            }
        }
        return cell
    }
    
    // MARK: - fetchNews
    private var newsRequest = PageRequest()
    private var lastDate: String?
    
    
    private func fetchDaily(lastDate: String?) {
        if let rc = self.refreshControl { rc.beginRefreshing() }
        newsRequest.fetchDaily(lastDate) {
            (page, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if page != nil {
                    if lastDate == nil { // Today
                        if self.lastDate == nil {
                            self.pages.append(page!)
                            self.lastDate = page?.date
                        } else {
                            self.pages[0] = page!
                        }
                    } else {
                        self.pages.append(page!)
                        self.lastDate = page?.date
                    }
                } else {
                    let msg = error ?? PageRequest.Error.UnknownError
                    let alert = UIAlertController(title: "Oops!", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Fine", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                if let rc = self.refreshControl { rc.endRefreshing() }
            }
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        fetchDaily(nil)
    }
    
    // MARK: - StoryThumbnails
    private var thumbImageCache = [Int: UIImage]()
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let storyWVC = segue.destinationViewController as? StoryWebViewController {
            if let cell = sender as? StoryTableViewCell {
                let url = cell.story?.share_url
                storyWVC.storyUrl = url
            }
        }
    }
    

}
