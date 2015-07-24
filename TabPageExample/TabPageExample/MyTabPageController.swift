//
//  MyTabPageController.swift
//  ScrollTabIndicatorExample
//
//  Created by Wizard Li on 7/20/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import TabPage

class MyTabPageController: TabPageController, TabScrollViewLayout {
    
    var data = ["hello_1", "hello_11", "hello_111", "hello_1111", "hello", "hello", "hello", "hello", "hello", "hello"]
    
    lazy var itemWidths : [CGFloat] = {
        [unowned self] in
        
        var widths = [CGFloat]()
        for title in self.data {
            let size = (title as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)])
            widths.append(size.width)
        }
        
        return widths
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabViewController.showsDorpDown = true
        tabViewController.indicatorColor = UIColor.blackColor()
        tabViewController.layoutDelegate = self
        
        tabViewController.dropDownHandler = {
            [unowned self] ()->Void in
            self.performSegueWithIdentifier("showMenuTitles", sender: self)
        }
        
        menuTitles = data
        
        reloadData(8)
        
        tabViewController.showRedDotHint(true, atIndex: 2)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func widthOfIndicatorForIndex(index: Int) -> CGFloat {
        return itemWidths[index]
    }
    
    func widthOfItemForIndex(index: Int) -> CGFloat {
        return itemWidths[index] + 30
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenuTitles" {
            let secondViewController = segue.destinationViewController as! MenuTitleCollectionViewController
            secondViewController.data = data
        }
    }
}