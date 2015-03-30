//
//  GYSegmentScrollViewController.swift
//  Flingy
//
//  Created by Grady Zhuo on 3/27/15.
//  Copyright (c) 2015 Skytiger Studio. All rights reserved.
//

import UIKit

struct GYSegmentUnit {
    let title:String
    let containerView:UIView
}


@objc protocol GYSegmentScrollViewControllerDataSource{
    
    optional func numberOfUnitInSegmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController)->Int
    optional func segmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController, titleOfSegmentIndex:Int) -> String
    func segmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController, containerViewOfSegmentIndex:Int) -> UIView
    
}

@objc protocol GYSegmentScrollViewControllerDelegate{
    
    optional func segmentScrollViewController(segmentScollViewController:GYSegmentScrollViewController, willScrollToIndex index:Int)
    optional func segmentScrollViewController(segmentScollViewController:GYSegmentScrollViewController, didScrollToIndex index:Int)
    
    
}

class GYSegmentScrollViewController: UIViewController, GYSegmentScrollViewControllerDataSource, GYSegmentScrollViewControllerDelegate, UIScrollViewDelegate {
    
    let scrollView:UIScrollView = UIScrollView()
    
    var constraints:[AnyObject] = []
    
    weak var dataSource:GYSegmentScrollViewControllerDataSource?
    weak var delegate:GYSegmentScrollViewControllerDelegate?
    
    private var segmentUnits:[GYSegmentUnit] = []
    
    private var isLayouted:Bool = false
    
    var selectedSegmentIndex:Int = 0{
        didSet{
            var targetOffsetX = CGFloat(selectedSegmentIndex) * self.view.bounds.width
            self.scrollView.contentOffset.x = targetOffsetX
        }
    }
    
    
    
    
    
    override func loadView() {
        
        self.scrollView.pagingEnabled = true
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.delegate = self
        
        self.scrollView.addObserver(self, forKeyPath: "delegate", options: NSKeyValueObservingOptions.New, context: nil)
        self.scrollView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
        
        self.view = self.scrollView

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reloadData(){

        assert(class_respondsToSelector(object_getClass(self.dataSource), "segmentScrollViewController:containerViewOfSegmentIndex:"), "segmentScrollViewController:containerViewOfSegmentIndex: is needed to implement.")
        
        self.view.removeConstraints(self.constraints)
        
        var countOfSegment:Int = 0
        
        if let dataSource = self.dataSource {
            
            if class_respondsToSelector(object_getClass(dataSource), "numberOfUnitInSegmentScrollViewController:") {
                countOfSegment = (dataSource.numberOfUnitInSegmentScrollViewController?(self)) ?? 0
            }
            
            for index in 0..<countOfSegment {
                
                var title = ""
                if class_respondsToSelector(object_getClass(dataSource), "segmentScrollViewController:titleOfSegmentIndex:") {
                    title = (dataSource.segmentScrollViewController?(self, titleOfSegmentIndex: index)) ?? ""
                }
                
                var containerView = dataSource.segmentScrollViewController(self, containerViewOfSegmentIndex: index)
                containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.scrollView.addSubview(containerView)
                
                var unit = GYSegmentUnit(title: title, containerView: containerView)
                
                var constraints = [AnyObject]()
                
                var referenceView = self.view
                var referenceAttribute:NSLayoutAttribute = .Leading
                if index > 0 {
                    referenceView = self.segmentUnits[index-1].containerView
                    referenceAttribute = .Trailing
                }
                
                var lConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: referenceAttribute, multiplier: 1.0, constant: 0)
                var tConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)

                
                constraints += [lConstraint, tConstraint]
                
                var wConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
                var hConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
                
                
                constraints += [wConstraint, hConstraint]
                
                self.constraints = constraints
                
                self.view.addConstraints(constraints)
                
                self.segmentUnits += [unit]
                
            }
            
            self.view.setNeedsLayout()
            
        }

        
    }
    
    
    //
    
    private func targetIndex(fromContentOffset contentOffset:CGPoint)->Int{
        var scrollViewBounds = self.scrollView.bounds
        var index = Int(ceil(contentOffset.x / scrollViewBounds.width))
        return index
    }
    
    
    func relayout(){
        
        var countOfSegmentUnits = CGFloat(self.segmentUnits.count)
        self.scrollView.contentSize.width = self.view.bounds.width * countOfSegmentUnits //CGSize(width: , height: self.view.bounds.height)
        
    }
    
    
    //
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if object === self.view  && keyPath == "frame" {
            var newFrame = (change[NSKeyValueChangeNewKey] as? NSValue)?.CGRectValue()
            var oldFrame = (change[NSKeyValueChangeOldKey] as? NSValue)?.CGRectValue()
            
            if let oldFrame = oldFrame {
                
                if let newFrame = newFrame {
                    
                    if newFrame.size != oldFrame.size {
                        
                        self.relayout()
                        
                    }
                    
                }
                
            }
            
        }
        
        
        if object === self.view && keyPath == "delegate"{
            assertionFailure("Just can't modify the scrollView's delegate from me.")
        }
        
        
    }
    
    
    
    
    //
    
    func numberOfUnitInSegmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController) -> Int {
        return 0
    }

    func segmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController, containerViewOfSegmentIndex: Int) -> UIView {
        
        var view = UIView()
        view.backgroundColor = UIColor.redColor()
        
        return view
    }
    
    func segmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController, titleOfSegmentIndex: Int) -> String {
        return ""
    }
    
    //
    func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, didScrollToIndex index: Int) {
        
    }
    
    func segmentScrollViewController(segmentScollViewController: GYSegmentScrollViewController, willScrollToIndex index: Int) {
        
    }
    
    //
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.selectedSegmentIndex = self.targetIndex(fromContentOffset: scrollView.contentOffset)
        
        if let delegate = self.delegate {
            
            if class_respondsToSelector(object_getClass(delegate), "segmentScrollViewController:didScrollToIndex:") {
                delegate.segmentScrollViewController?(self, didScrollToIndex: self.selectedSegmentIndex)
            }
            
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var index = self.targetIndex(fromContentOffset: targetContentOffset.memory)
        if let delegate = self.delegate {
            
            if class_respondsToSelector(object_getClass(delegate), "segmentScrollViewController:willScrollToIndex:") {
                delegate.segmentScrollViewController?(self, willScrollToIndex: index)
            }
            
        }
        
        
    }
    
    
}
