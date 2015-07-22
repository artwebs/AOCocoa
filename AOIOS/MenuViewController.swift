//
//  MenuViewController.swift
//  AOCocoa
//
//  Created by 刘洪彬 on 15/7/14.
//  Copyright (c) 2015年 刘洪彬. All rights reserved.
//
import AOCocoa

class MenuViewController: UIViewController {
    
    override func viewDidLoad(){
        var helpView:AOHelpView = AOHelpView(frame: self.view.bounds)
        helpView.imageArr=["help1.jpg","help2.jpg"];
        helpView.drawView()
        self.view.addSubview(helpView)
        
        
        
//        var loadImageView: UIImageView = UIImageView(image: Utils.loadImageCacheWithUrl("http://www.xhynt.com/xinhuasheapp-management/area_android_img/530000.jpg", defaultImage: "help1.jpg"))
//        loadImageView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//        self.view.addSubview(loadImageView)
        
        var loadImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        loadImageView.image=UIImage(contentsOfFile: "help1.jpg")
        Utils.loadImageCacheWithUrl("http://www.xhynt.com/xinhuasheapp-management/area_android_img/530000.jpg", callback: { (image) -> Void in
            loadImageView.image=image
        })
        self.view.addSubview(loadImageView)
        
    
    }
    
}
