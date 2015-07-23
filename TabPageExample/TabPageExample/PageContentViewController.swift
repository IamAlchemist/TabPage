//
//  PageContentViewController.swift
//  ScrollTabIndicatorExample
//
//  Created by Wizard Li on 7/21/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit
import TabPage
import WebImage

class PageContentViewController : UICollectionViewController, TabPageIndex
{
    var internalIndex : Int = 0
    
    var data = [String]()
    
    var index : Int {
        get{
            return internalIndex
        }
        
        set{
            internalIndex = newValue
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PageContentCell", forIndexPath: indexPath) as! PageContentCell
        
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.imageView.setImageWithURL(NSURL(string: data[indexPath.row])!, activityStyle: UIActivityIndicatorViewStyle.White)
        
        //cell.imageView.sd_setImageWithURL(NSURL(string: data[indexPath.row]))
        
        return cell
    }
}