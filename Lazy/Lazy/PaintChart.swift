//
//  ChartView.swift
//  Lazy
//
//  Created by Kiran Kunigiri on 1/30/16.
//  Copyright © 2016 Kiran Kunigiri. All rights reserved.
//

import UIKit
import C4

class PaintChart: UIButton {

    var ratio: CGFloat = 0;

//    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
//                Chart.drawChart(frame: CGRectMake(0, 0, CGFloat(self.frame.width), CGFloat(self.frame.height)), ratio: 0.8)
//    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        Chart.drawChart(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), ratio: ratio)
    }
    
    func setNewRatio(newRatio: CGFloat) {
        self.ratio = newRatio
    }


}
