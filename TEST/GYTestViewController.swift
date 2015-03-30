//
//  GYTestViewController.swift
//  TEST
//
//  Created by Grady Zhuo on 3/30/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit

class GYTestViewController: GYSegmentScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfUnitInSegmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController) -> Int {
        return 3
    }
    
    override func segmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController, containerViewOfSegmentIndex: Int) -> UIView {
        return UITableView()
    }
    
    override func segmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController, titleOfSegmentIndex: Int) -> String {
        return "123"
    }
    
    override func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, didScrollToIndex index: Int) {
        println("index:\(index)")
    }
    
    override func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, willScrollToIndex index: Int) {
        println("index:\(index)")
    }
    
    
}
