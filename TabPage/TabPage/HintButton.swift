//
//  HintButton.swift
//  TabPage
//
//  Created by Wizard Li on 7/20/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit

class HintButton : UIView
{
    let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    let redDotWidth : CGFloat = 6
    
    var showsHint : Bool = false {
        didSet {
            redDot.hidden = !showsHint
        }
    }
    
    var redDot = UIView()
    
    override func layoutSubviews() {
        button.frame = bounds
        redDot.frame = CGRectMake(bounds.width - redDotWidth - 5, 0 + 5, redDotWidth, redDotWidth)
    }
    
    init(){
        super.init(frame: CGRectZero)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        addSubview(button)
        addSubview(redDot)
        redDot.backgroundColor = UIColor.redColor()
        redDot.layer.cornerRadius = redDotWidth / 2
        showsHint = false
    }
}