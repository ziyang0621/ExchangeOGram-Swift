//
//  TimeLineTableViewController.swift
//  ExchangeOGram
//
//  Created by Ziyang Tan on 2/16/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class TimeLineTableViewController: PFQueryTableViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Message"
        self.textKey = "textContent"
        self.imageKey = "messageImage"
        self.title = "Timeline"
        self.paginationEnabled = true
        self.objectsPerPage = 7
    }
    
    override func queryForTable() -> PFQuery! {
        let query = PFQuery(className: self.parseClassName)
        
        if self.objects.count == 0 {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad || (UIDevice.currentDevice().userInterfaceIdiom == .Phone && UIScreen.mainScreen().bounds.width == 736) {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.textLabel?.text != "Load more ..." {
                self.performSegueWithIdentifier("showDetail", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var indexPath:NSIndexPath? = nil
            
            if self.tableView.indexPathForSelectedRow() == nil {
                indexPath = NSIndexPath(forRow: 0, inSection: 0)
            } else {
                indexPath = tableView.indexPathForSelectedRow()
            }
            
            let message = self.objects[indexPath!.row] as PFObject
            
            let detailViewController = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            detailViewController.detailItem = message
            
            detailViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width >= 736 {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
}
