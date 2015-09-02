//
//  SentMemesTVC.swift
//  Meme 2.0
//
//  Created by Leonid Pustilnik on 8/31/15.
//  Copyright (c) 2015 Leonid Pustilnik. All rights reserved.
//

import UIKit

class SentMemesTVC: UITableViewController {
    let reuseIdentifier = "MemeTableViewCell"
    
    var memes : [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailVC
        detailController.memes = self.memes[indexPath.row] as Meme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}

