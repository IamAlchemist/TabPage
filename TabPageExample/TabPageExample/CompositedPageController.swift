//
//  CompositedPageController.swift
//  ScrollTabIndicatorExample
//
//  Created by Wizard Li on 7/21/15.
//  Copyright (c) 2015 morgenworks. All rights reserved.
//

import Foundation
import UIKit
import TabPage
import SnapKit
import WebImage

class CompositedPageController : UIViewController, TabPageDataSource
{
    @IBOutlet weak var backButton: UIButton!
    
    let tabPageController = TabPageController()
    
    let titles = ["喵星人", "美女", "很好的汽车", "非常漂亮的灯"]
    let images = [
        "喵星人" : ["http://img0.imgtn.bdimg.com/it/u=449319572,840438856&fm=21&gp=0.jpg",
            "http://img0.imgtn.bdimg.com/it/u=2483562809,3309193823&fm=21&gp=0.jpg",
            "http://img1.imgtn.bdimg.com/it/u=2140194120,3181925453&fm=21&gp=0.jpg",
            "http://img0.imgtn.bdimg.com/it/u=723404967,3927925015&fm=21&gp=0.jpg",
            "http://img4.imgtn.bdimg.com/it/u=3356449941,189017095&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=3818079195,3464281518&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=2665857198,3235332519&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=95995246,2640393589&fm=21&gp=0.jpg",
            "http://img0.imgtn.bdimg.com/it/u=719437484,505277734&fm=21&gp=0.jpg",
            "http://img4.imgtn.bdimg.com/it/u=3035683951,1365451075&fm=21&gp=0.jpg"],
        
        "美女" : ["http://f.hiphotos.baidu.com/image/h%3D300/sign=05cb47c0aac3793162688029dbc5b784/a1ec08fa513d269724d58d9b50fbb2fb4216d8f6.jpg",
            "http://b.hiphotos.baidu.com/image/h%3D300/sign=be5a59d2bd99a90124355d362d940a58/2934349b033b5bb56880a53833d3d539b700bca5.jpg",
            "http://a.hiphotos.baidu.com/image/h%3D360/sign=08dd5c1aa3efce1bf52bcecc9f50f3e8/d000baa1cd11728bdf2293ceccfcc3cec2fd2cca.jpg",
            "http://g.hiphotos.baidu.com/image/h%3D300/sign=543efd1b2b738bd4db21b431918a876c/f7246b600c3387446572adba540fd9f9d62aa045.jpg",
            "http://c.hiphotos.baidu.com/image/h%3D360/sign=742cd8a34fed2e73e3e9802ab701a16d/6a63f6246b600c33c512e9ef1f4c510fd9f9a1a9.jpg",
            "http://f.hiphotos.baidu.com/image/h%3D360/sign=e8adaa6e4310b912a0c1f0f8f3fffcb5/42a98226cffc1e17af3e61e44e90f603728de966.jpg",
            "http://b.hiphotos.baidu.com/image/h%3D360/sign=ff08b4370a2442a7b10efba3e142ad95/4d086e061d950a7b6351c0700fd162d9f2d3c91a.jpg",
            "http://h.hiphotos.baidu.com/image/h%3D360/sign=9af7917fb7fb4316051f7c7c10a54642/ac345982b2b7d0a2ab6ef529ceef76094a369adb.jpg"],
            
        "很好的汽车" : ["http://img2.imgtn.bdimg.com/it/u=679614889,4219762343&fm=21&gp=0.jpg",
            "http://img4.imgtn.bdimg.com/it/u=68723717,3629212337&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=415583980,2095075321&fm=21&gp=0.jpg",
            "http://img2.imgtn.bdimg.com/it/u=856974007,2749385137&fm=21&gp=0.jpg",
            "http://img2.imgtn.bdimg.com/it/u=858279863,3351909273&fm=21&gp=0.jpg",
            "http://img1.imgtn.bdimg.com/it/u=3510179486,2522941899&fm=21&gp=0.jpg",
            "http://img3.imgtn.bdimg.com/it/u=3368372820,2050831699&fm=21&gp=0.jpg",
            "http://img0.imgtn.bdimg.com/it/u=3669314870,2609131400&fm=21&gp=0.jpg",
            "http://img0.imgtn.bdimg.com/it/u=388920801,387632271&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=1774394606,323770629&fm=21&gp=0.jpg"],
            
        "非常漂亮的灯" : ["http://img5.imgtn.bdimg.com/it/u=2238286471,3458391338&fm=21&gp=0.jpg",
            "http://img1.imgtn.bdimg.com/it/u=2531133161,3716639460&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=1213416821,4214691346&fm=21&gp=0.jpg",
            "http://img2.imgtn.bdimg.com/it/u=3949451895,1094291907&fm=21&gp=0.jpg",
            "http://img3.imgtn.bdimg.com/it/u=2984811857,4214566472&fm=21&gp=0.jpg",
            "http://img4.imgtn.bdimg.com/it/u=502657058,1966003820&fm=21&gp=0.jpg",
            "http://img5.imgtn.bdimg.com/it/u=3031754499,456278888&fm=21&gp=0.jpg"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabPageController.dataSource = self
        tabPageController.tabTopOffset = 0
        
//        tabPageController.tabViewController.showsIndicator = false
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        tabPageController.tabViewController.menuItemBackgroundColor = color
        
        addChildViewController(tabPageController)
        view.addSubview(tabPageController.view)
        tabPageController.didMoveToParentViewController(self)
        
        tabPageController.view.snp_makeConstraints {
            [unowned self]
            (make) -> Void in
            make.top.equalTo(self.backButton.snp_bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        tabPageController.menuTitles = titles
        tabPageController.reloadData(0)
    }
    
    func viewControllerForIndex(index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        vc.index = index
        
        vc.data = images[titles[index]]!
        
        return vc
    }
}