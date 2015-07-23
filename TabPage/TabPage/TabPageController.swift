//
//  TabPageController.swift
//  TabPage
//
//  Created by Wizard Li on 7/17/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public protocol TabPageIndex{
    var index : Int {get set}
}

public protocol TabPageDataSource
{
    func viewControllerForIndex(index : Int) -> UIViewController
}

public class ExamplePageContentViewController : UIViewController, TabPageIndex {
    var internalIndex : Int = 0
    
    public var index : Int {
        get{
            return internalIndex
        }
        
        set{
            internalIndex = newValue
        }
    }
}


public class DefaultTabPageDataSource: NSObject, TabPageDataSource {
    public func viewControllerForIndex(index: Int) -> UIViewController
    {
        let colors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.cyanColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.grayColor(), UIColor.whiteColor(), UIColor.lightGrayColor()]

        let vc = ExamplePageContentViewController()
//        let bundle = NSBundle(forClass: TabPageController.self)
//        let storyBoard = UIStoryboard(name: "TabPage", bundle: bundle)
//        let vc = storyBoard.instantiateViewControllerWithIdentifier("DefaultPageContentViewController") as! UIViewController
        
        vc.view.backgroundColor = colors[index % colors.count]
        vc.index = index
        
        return vc
    }
}

public class TabPageController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{    
    public var menuTitles : [String] {
        set {
            tabViewController.menuTitles = newValue
        }
        
        get {
            return tabViewController.menuTitles
        }
    }
    
    public var tabTopOffset : CGFloat = 20
    
    public var tabViewController = TabScrollViewController()
    
    public var dataSource : TabPageDataSource = DefaultTabPageDataSource()
    
    public var currentIndex : Int {
        set{
            internalIndex = newValue
            showTabViewAtIndex(internalIndex)
            showPageViewAtIndex(internalIndex)
        }
        
        get{
            return internalIndex
        }
        
    }
    
    var internalIndex : Int = 0
    
    var pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
        navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
        options: nil)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tabViewController.menuItemTapHandler = {
            [unowned self]
            (index : Int) in
            
            let vcs = [self.dataSource.viewControllerForIndex(index)]
            self.pageViewController.setViewControllers(vcs,
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: false,
                completion: nil)
        }
        
        addChildViewController(tabViewController)
        let superview = self.view
        superview.addSubview(tabViewController.view)
        tabViewController.view.snp_makeConstraints{
            (make) -> Void in
            make.top.equalTo(superview).offset(tabTopOffset)
            make.left.equalTo(superview)
            make.right.equalTo(superview)
            make.height.equalTo(tabViewController.tabHeight)
        }
        tabViewController.didMoveToParentViewController(self)
        

        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        self.addChildViewController(pageViewController)
        
        self.view.addSubview(pageViewController.view)
        pageViewController.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.tabViewController.view.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        pageViewController.didMoveToParentViewController(self)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func reloadData(index : Int)
    {
        tabViewController.update()
        currentIndex = index
    }
    
    func showTabViewAtIndex(index : Int)
    {
        tabViewController.currentIndex = index
    }
    
    func showPageViewAtIndex(index : Int)
    {
        let vcs = [dataSource.viewControllerForIndex(index)];
        pageViewController.setViewControllers(vcs,
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: false,
            completion: nil)
    }
    
    // MARK: - 
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index : Int = 0
        
        if let vc = viewController as? TabPageIndex {
            index = vc.index + 1
        }
        
        if (index >= 0 && index < menuTitles.count){
            return dataSource.viewControllerForIndex(index)
        }
        else{
            return nil
        }
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index : Int = 0
        
        if let vc = viewController as? TabPageIndex {
            index = vc.index - 1
        }
        
        if (index >= 0 && index < menuTitles.count){
            return dataSource.viewControllerForIndex(index)
        }
        else{
            return nil
        }
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if finished {
            if let vc = pageViewController.viewControllers[0] as? TabPageIndex {
                showTabViewAtIndex(vc.index)
            }
        }
    }
    
}
