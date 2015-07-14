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
        
    }
    
}
