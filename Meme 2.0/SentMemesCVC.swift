//
//  SentMemesCVC.swift
//  Meme 2.0
//
//  Created by Leonid Pustilnik on 8/31/15.
//  Copyright (c) 2015 Leonid Pustilnik. All rights reserved.
//

import UIKit

class SentMemesCVC: UICollectionViewController , UICollectionViewDataSource {
    
    var memes : [Meme]!
    let reuseIdentifier = "MemeCollectionViewCell"
    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        let space : CGFloat = 3.0
        let width = (self.view.frame.width - (2 * space)) / 3.0
        let height = (self.view.frame.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(width, height)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        
        self.collectionView?.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let meme = memes[indexPath.item]
        let imageView =  UIImageView(image: meme.imageView)
        cell.backgroundView = imageView
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as? MemeDetailVC
        detailController!.memes = self.memes[indexPath.row] as Meme
        self.navigationController!.pushViewController(detailController!, animated: true)
        
    }
    
    
    
}
