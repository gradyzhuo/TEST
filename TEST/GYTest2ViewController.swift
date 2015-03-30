//
//  GYTest2ViewController.swift
//  TEST
//
//  Created by Grady Zhuo on 3/30/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit

class GYTest2ViewController: GYSegmentScrollViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func numberOfUnitInSegmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController) -> Int {
        return 3
    }
    
    func segmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController, containerViewOfSegmentIndex index: Int) -> UIView {

        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = index
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }
    
    override func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, didScrollToIndex index: Int) {
        println("index:\(index)")
    }
    
    override func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, willScrollToIndex index: Int) {
        println("index:\(index)")
    }
    
    
    //MARK: -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 100 : 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }

    
}
