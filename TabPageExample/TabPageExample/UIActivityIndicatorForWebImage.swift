//
//  UIActivityIndicatorForWebImage.swift
//  ScrollTabIndicatorExample
//
//  Created by Wizard Li on 7/21/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit
import WebImage

extension UIImageView
{
    private struct AssociatedKey {
        static var ActivityIndicatorName = "UIActivityIndicatorForWebImageActivityIndicator"
    }
    
    var activityIndicator : UIActivityIndicatorView? {
        get{
            return objc_getAssociatedObject(self, &AssociatedKey.ActivityIndicatorName) as? UIActivityIndicatorView
        }
        
        set{
            objc_setAssociatedObject(self,
                &AssociatedKey.ActivityIndicatorName,
                newValue as UIActivityIndicatorView?,
                UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    private func addActivityIndicatorWithStyle(activityStyle : UIActivityIndicatorViewStyle)
    {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: activityStyle)
            activityIndicator?.autoresizingMask = UIViewAutoresizing.None
            updateActivityIndicatorFrame()
            self.addSubview(self.activityIndicator!)
        }
        
        self.activityIndicator?.startAnimating()
    }
    
    private func updateActivityIndicatorFrame() {
        if let indicator = activityIndicator {
            let indicatorBounds = indicator.bounds;
            let x = (frame.width - indicatorBounds.width) / 2.0
            let y = (frame.height - indicatorBounds.height) / 2.0
            indicator.frame = CGRectMake(x, y, indicatorBounds.width, indicatorBounds.height)
        }
    }
    
    private func removeActivityIndicator(){
        if let indicator = activityIndicator  {
            indicator.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateActivityIndicatorFrame()
    }
    
    func setImageWithURL(url : NSURL, activityStyle: UIActivityIndicatorViewStyle)
    {
        setImageWithURL(url, placeHolder: nil, options: SDWebImageOptions.allZeros, progress: nil, completion: nil, activityStyle: activityStyle)
    }
    
    func setImageWithURL(url : NSURL, placeHolder: UIImage!, options:SDWebImageOptions, progress:SDWebImageDownloaderProgressBlock!, completion:SDWebImageCompletionBlock!, activityStyle: UIActivityIndicatorViewStyle)
    {
        addActivityIndicatorWithStyle(activityStyle)

        sd_setImageWithURL(url, placeholderImage: placeHolder, options: options, progress: progress) {
            [unowned self]
            (image, err, cacheType, imageURL) -> Void in
            
            if let error = err{
                println("\(err.localizedDescription)")
            }
            
            if let block = completion {
                block(image, err, cacheType, imageURL)
            }
            
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
}
