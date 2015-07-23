//
//  TabScrollViewController.swift
//  TabPage
//
//  Created by Wizard Li on 7/17/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public protocol TabScrollViewLayout {
    func widthOfItemForIndex(index : Int) -> CGFloat
    func widthOfIndicatorForIndex(index : Int) -> CGFloat
}

public class TabScrollViewController : UIViewController
{
    public var tabHeight : CGFloat = 40
    
    public var tabBackground  = UIColor.yellowColor()
    
    public var tabTextColorHighLighted = UIColor.blackColor()
    
    public var tabTextColor = UIColor.lightGrayColor()
    
    public var tabFontSize : CGFloat = 15
    
    lazy public var tabFont : UIFont = {
        [unowned self] in
        return UIFont.systemFontOfSize(self.tabFontSize)
        }()
    
    public var indicatorHeight : CGFloat = 2
    
    public var indicatorColor = UIColor.redColor() {
        didSet{
            indicator.backgroundColor = indicatorColor
        }
    }
    
    public var menuItemBackgroundColor : UIColor?
    
    public var tabButtonPadding : CGFloat = 20
    
    public var layoutDelegate : TabScrollViewLayout?
    
    public lazy var dropDownImageView : UIImageView = {
        let view = UIImageView()
        view.hidden = true
        return view
    }()
    
    public var dropDownImage = UIImage(named: "btn_uparrow")
    
    public var showsIndicator  = true
    
    public var showsDorpDown = false {
        didSet{
            dropDownImageView.hidden = !showsDorpDown
        }
    }
    
    public var dropDownHandler : (()->Void)?
    
    var menuItemTapHandler : ((index : Int)->Void)?
    
    var menuTitles = [String]()
    
    var currentIndex : Int = -1 {
        didSet{
            if oldValue != currentIndex
            {
                var newIndex : Int?
                
                if oldValue >= 0 && oldValue < buttons.count{
                    buttons[oldValue].button.enabled = true
                    buttons[oldValue].backgroundColor = UIColor.clearColor()
                }
                
                if currentIndex >= 0 && currentIndex < buttons.count {
                    buttons[currentIndex].button.enabled = false
                    if let color = menuItemBackgroundColor {
                        buttons[currentIndex].backgroundColor = color
                    }
                    newIndex = currentIndex
                }
                
                if showsIndicator && (newIndex != nil) {
                    moveUnderLineToIndex(newIndex!)
                }
                
                if newIndex != nil {
                    let rect = buttons[newIndex!].frame
                    scrollView.scrollRectToVisible(rect, animated: true)
                }
            }
        }
    }
    
    private var scrollView = UIScrollView(frame: CGRectZero)
    
    private var buttonWidths = [CGFloat]()
    
    private var buttons = [HintButton]()
    
    private var totalWidth : CGFloat {
        get{
            var result : CGFloat = 0
            
            if let layout = layoutDelegate {
                for (index, title) in enumerate(menuTitles) {
                    result += layout.widthOfItemForIndex(index)
                }
            }
            else{
                for width in buttonWidths {
                    result += width
                }
            }
            
            return result
        }
    }
    
    private var indicator : UIView = UIView(frame: CGRectZero)
    
    // MARK: -
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        scrollView.backgroundColor = tabBackground
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(dropDownImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dropDownButtonPressed:"))
        dropDownImageView.addGestureRecognizer(tapGesture)
        
        update()
        
        indicator.backgroundColor = UIColor.redColor()
        self.scrollView.addSubview(indicator)
        indicator.hidden = !showsIndicator
        
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSubviews()
    }
    
    public func showRedDotHint(show : Bool, atIndex: Int)
    {
        if atIndex >= 0 && atIndex < buttons.count{
            buttons[atIndex].showsHint = show
        }
    }
    
    func dropDownButtonPressed(sender: UITapGestureRecognizer)
    {
        if let handler = dropDownHandler {
            handler()
        }
    }
    
    func update()
    {
        clearButtons()
        
        var startX : CGFloat = 0
        
        for (index, title) in enumerate(menuTitles) {
            let size = (title as NSString).sizeWithAttributes([NSFontAttributeName: tabFont])
            let buttonWidth = size.width + 2 * tabButtonPadding
            buttonWidths.append(buttonWidth)
            
            let hintButton = HintButton()
            hintButton.button.setTitle(title, forState: UIControlState.Normal)
            hintButton.button.setTitleColor(tabTextColor, forState: UIControlState.Normal)
            hintButton.button.setTitleColor(tabTextColorHighLighted, forState: UIControlState.Disabled)
            hintButton.button.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
            hintButton.button.tag = index
            
            buttons.append(hintButton)
            
            scrollView.addSubview(hintButton)
        }
        
        updateSubviews()
    }
    
    func buttonPressed(sender: UIButton)
    {
        currentIndex = sender.tag
        if let handler = menuItemTapHandler {
            handler(index: self.currentIndex)
        }
    }
    
    // MARK: -
    private func updateSubviews()
    {
        var startX : CGFloat = 0
        
        if !showsDorpDown {
            scrollView.frame = view.bounds
        }
        else {
            scrollView.frame = CGRectMake(0, 0, view.bounds.width - tabHeight, view.bounds.height)
        }
        
        for(index, title) in enumerate(buttons){
            buttons[index].frame = frameOfItem(index)
        }
        
        scrollView.contentSize = CGSizeMake(totalWidth, view.frame.height)
        indicator.frame = frameOfIndicator(currentIndex)
        
        dropDownImageView.frame = CGRectMake(view.bounds.width - tabHeight, 0, tabHeight, tabHeight)
        dropDownImageView.contentMode = UIViewContentMode.Center
        dropDownImageView.userInteractionEnabled = true
        dropDownImageView.backgroundColor = tabBackground
        dropDownImageView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        
        showShadowForView(dropDownImageView, shadowRadius: 20, shadowOpacity: 20)
        
        
        dropDownImageView.image = dropDownImage
    }
    
    private func showShadowForView(view: UIView, shadowRadius: CGFloat, shadowOpacity: Float)
    {
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = shadowOpacity
    }
    
    private func clearButtons()
    {
        buttonWidths = []
        for button in buttons {
            button.removeFromSuperview()
        }
        
        buttons = []
    }
    
    private func frameOfItem(index : Int) -> CGRect
    {
        if (index >= 0)
        {
            var x : CGFloat = 0
            var width : CGFloat = 0
            
            if let layout = layoutDelegate {
                width = layout.widthOfItemForIndex(index)
                
                for idx in 0..<index {
                    x += layout.widthOfItemForIndex(idx)
                }
            }
            else{
                width = buttonWidths[index]
                
                for idx in 0..<index {
                    x += buttonWidths[idx]
                }
            }
            
            return CGRectMake(x, 0, width, scrollView.frame.height)
        }
        else
        {
            return CGRectZero
        }
    }
    
    private func frameOfIndicator(index : Int) -> CGRect
    {
        if index >= 0
        {
            var x : CGFloat = 0
            var width : CGFloat = 0

            if let layout = layoutDelegate {
                width = layout.widthOfIndicatorForIndex(index)
                
                for idx in 0..<index {
                    x += layout.widthOfItemForIndex(idx)
                }
                
                x += CGFloat(Int((layout.widthOfItemForIndex(index) - width) / 2 + 0.5))
            }
            else{
                if index >= 0 && index < buttonWidths.count {
                    width = buttonWidths[index]
                    
                    for idx in 0..<index {
                        x += buttonWidths[idx]
                    }
                }
            }
            
            return CGRectMake(x, scrollView.frame.height - indicatorHeight, width, indicatorHeight)
        }
        else
        {
            return CGRectZero
        }
    }
    
    private func moveUnderLineToIndex(index : Int)
    {
        if showsIndicator {
            UIView.animateWithDuration(0.2,
                delay: 0,
                options: UIViewAnimationOptions.AllowUserInteraction,
                animations: { () -> Void in
                    self.indicator.frame = self.frameOfIndicator(index)
                },
                completion: nil)
        }
    }
    
}