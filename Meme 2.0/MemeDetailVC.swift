//
//  MemeDetailVC.swift
//  Meme 2.0
//
//  Created by Leonid Pustilnik on 8/31/15.
//  Copyright (c) 2015 Leonid Pustilnik. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    @IBOutlet weak var detailView: UIImageView!
    
    var memes : Meme!
    
    override func viewWillAppear(animated: Bool) {
        
        
        self.detailView.image! = memes.memedImage
        
        
        
    }
    
}
