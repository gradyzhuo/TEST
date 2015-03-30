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
    let index:Int
}

let GYSegmentVCAdderPrefix = "segment_adder_"


@objc protocol GYSegmentScrollViewControllerDataSource{
    
    optional func numberOfUnitInSegmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController)->Int
//    optional func segmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController, titleOfSegmentIndex:Int) -> String
    optional func segmentScrollViewController(segmentScrollViewController:GYSegmentScrollViewController, containerViewOfSegmentIndex:Int) -> UIView
    
}

@objc protocol GYSegmentScrollViewControllerDelegate{
    
    optional func segmentScrollViewController(segmentScollViewController:GYSegmentScrollViewController, willScrollToIndex index:Int)
    optional func segmentScrollViewController(segmentScollViewController:GYSegmentScrollViewController, didScrollToIndex index:Int)
    
    
}

class GYSegmentScrollViewController: UIViewController, GYSegmentScrollViewControllerDataSource, GYSegmentScrollViewControllerDelegate, UIScrollViewDelegate {
    
    let scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        return scrollView
    }()
    
    var scrollViewConstraints = [AnyObject]()
    var constraints:[AnyObject] = []
    
    weak var dataSource:GYSegmentScrollViewControllerDataSource?
    weak var delegate:GYSegmentScrollViewControllerDelegate?
    
    private var segmentUnits:[GYSegmentUnit] = []
    private var privateObjectInfo = ObjectInfo()
    private var isLayouted:Bool = false
    
    var selectedSegmentIndex:Int{
        set{
            var targetOffsetX = CGFloat(selectedSegmentIndex) * self.view.bounds.width
            self.scrollView.contentOffset.x = targetOffsetX
            
            self.privateObjectInfo.selectedSegmentIndex = selectedSegmentIndex
        }
        get{
            return self.privateObjectInfo.selectedSegmentIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.insertSubview(self.scrollView, atIndex: 0)

        self.scrollView.delegate = self

        self.scrollView.addObserver(self, forKeyPath: "delegate", options: NSKeyValueObservingOptions.New, context: nil)
//        self.scrollView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
        
        
        self.dataSource = self
        self.delegate = self

        self.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        self.relayout()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.view.removeConstraints(self.scrollViewConstraints)
        self.scrollViewConstraints.removeAll(keepCapacity: false)
        
        var tConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
        var bConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: 0)
        var lConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        var rConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        self.scrollViewConstraints = [tConstraint, bConstraint, lConstraint, rConstraint]
        self.view.addConstraints(self.scrollViewConstraints)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    private func targetIndex(fromContentOffset contentOffset:CGPoint)->Int{
        var scrollViewBounds = self.scrollView.bounds
        var index = Int(ceil(contentOffset.x / scrollViewBounds.width))
        return index
    }
    
    
    func relayout(){
        
        //CGSize(width: , height: self.view.bounds.height)
        var countOfSegmentUnits = CGFloat(self.segmentUnits.count)
        self.scrollView.contentSize.width = self.view.bounds.width * countOfSegmentUnits
        
        self.scrollView.removeConstraints(self.constraints)
        
        for unit in self.segmentUnits {
            
            self.addContainerViewConstraints(unit.containerView, index: unit.index)
        }
        
    }
    
    func reloadData(){
        
        self.scrollView.removeConstraints(self.constraints)
        
        var countOfSegment:Int = 0
        
        if let dataSource = self.dataSource {
            
            if class_respondsToSelector(object_getClass(dataSource), "numberOfUnitInSegmentScrollViewController:") {
                countOfSegment = (dataSource.numberOfUnitInSegmentScrollViewController?(self)) ?? 0
            }
            
            for index in 0..<countOfSegment {
                
                
                if class_respondsToSelector(object_getClass(dataSource), "segmentScrollViewController:containerViewOfSegmentIndex:") {
                    
                    if let containerView = dataSource.segmentScrollViewController?(self, containerViewOfSegmentIndex: index) {
                        
                        
                        self.addView(containerView, index: index)


                    }

                    
                }else{
                    var identifier = "\(GYSegmentVCAdderPrefix)\(index)"
                    self.performSegueWithIdentifier(identifier, sender: index)
                    
                }

                
                
            }
            
            self.scrollView.setNeedsLayout()
            
        }

        
    }
    
    func addViewController(viewController:UIViewController, index:Int) {
        
        viewController.willMoveToParentViewController(self)
        self.addChildViewController(viewController)
        self.addView(viewController.view, index: index)
        viewController.didMoveToParentViewController(self)
        
        viewController.updateViewConstraints()
        viewController.view.setNeedsLayout()
        
    }
    
    func addView(containerView:UIView, index:Int) {
        
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.scrollView.addSubview(containerView)
        
        var unit = GYSegmentUnit(title: "", containerView: containerView, index: index)
        self.segmentUnits += [unit]
    }
    
    func addContainerViewConstraints(containerView:UIView, index:Int){
        
        var constraints = [AnyObject]()
        
        var referenceView:UIView = self.scrollView
        var referenceAttribute:NSLayoutAttribute = .Leading
        if index > 0 {
            referenceView = self.segmentUnits[index-1].containerView
            referenceAttribute = .Trailing
        }
        
        var lConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: referenceAttribute, multiplier: 1.0, constant: 0)
        var tConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -(self.topLayoutGuide.length))
        
        
        constraints += [lConstraint, tConstraint]
        
        var wConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        var hConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        
        
        constraints += [wConstraint, hConstraint]
        
        self.constraints += constraints
        
        self.scrollView.addConstraints(constraints)
        
    }
    
    
    //
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
//        if object === self.scrollView  && keyPath == "frame" {
//            var newFrame = (change[NSKeyValueChangeNewKey] as? NSValue)?.CGRectValue()
//            var oldFrame = (change[NSKeyValueChangeOldKey] as? NSValue)?.CGRectValue()
//            
//            if let oldFrame = oldFrame {
//                
//                if let newFrame = newFrame {
//                    
//                    if newFrame.size != oldFrame.size {
//                        
////                        self.reloadData()
////                        self.relayout()
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
        
        
        if object === self.scrollView && keyPath == "delegate"{
            assertionFailure("Just can't modify the scrollView's delegate from me.")
        }
        
        
    }
    
    
    
    
    //
    
    func numberOfUnitInSegmentScrollViewController(segmentScrollViewController: GYSegmentScrollViewController) -> Int {
        return 0
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
        
        
        if scrollView != self.scrollView {
            return
        }
        
        self.privateObjectInfo.selectedSegmentIndex = self.targetIndex(fromContentOffset: scrollView.contentOffset)
        
        if let delegate = self.delegate {
            
            if class_respondsToSelector(object_getClass(delegate), "segmentScrollViewController:didScrollToIndex:") {
                delegate.segmentScrollViewController?(self, didScrollToIndex: self.selectedSegmentIndex)
            }
            
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView != self.scrollView {
            return
        }
        
        var index = self.targetIndex(fromContentOffset: targetContentOffset.memory)
        if let delegate = self.delegate {
            
            if class_respondsToSelector(object_getClass(delegate), "segmentScrollViewController:willScrollToIndex:") {
                delegate.segmentScrollViewController?(self, willScrollToIndex: index)
            }
            
        }
        
        
    }
    
    deinit{
        self.scrollView.removeObserver(self, forKeyPath: "delegate")
//        self.scrollView.removeObserver(self, forKeyPath: "frame")
    }
    
    private struct ObjectInfo {
        var selectedSegmentIndex:Int = 0
    }
    
}
