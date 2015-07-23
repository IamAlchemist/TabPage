//
//  MenuTitleCollectionViewController.swift
//  ScrollTabIndicatorExample
//
//  Created by Wizard Li on 7/20/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

class MenuTitleCollectionViewController: UIViewController,
    UICollectionViewDataSource ,
    UICollectionViewDelegateFlowLayout{
    
    var selectedIndex : Int?
    var data = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuTitleCell", forIndexPath: indexPath) as! MenuTitleCell
        
        cell.title.text = data[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("channelSelected", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "channelSelected" {
            if let unwoundToMVC = segue.destinationViewController as? MyTabPageController , idx = selectedIndex{
                unwoundToMVC.currentIndex = idx
            }
        }
    }
}