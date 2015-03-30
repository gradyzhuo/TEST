//
//  GYSegmentViewAdderSegue.swift
//  TEST
//
//  Created by Grady Zhuo on 3/30/15.
//  Copyright (c) 2015 Grady Zhuo. All rights reserved.
//

import UIKit

class GYSegmentViewAdderSegue: UIStoryboardSegue {
   
    override func perform() {
        
        if let identifier = self.identifier {
            
            if identifier.hasPrefix(GYSegmentVCAdderPrefix) {
                
                var components = identifier.componentsSeparatedByString("_")
                if let index = components.last?.toInt() ?? 0 {
                    
                    var segmentScrollViewController = self.sourceViewController as GYSegmentScrollViewController
                    segmentScrollViewController.addViewController(self.destinationViewController as UIViewController, index: index)
                    
                }
                
                
            }
            
            
        }
    }
    
}
