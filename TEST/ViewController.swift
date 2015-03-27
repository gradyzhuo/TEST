//
//  ViewController.swift
//  TEST
//
//  Created by Grady Zhuo on 3/27/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scrollView.pagingEnabled = true
        self.scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width*2, height: UIScreen.mainScreen().bounds.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

