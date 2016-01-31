//
//  ChartView.swift
//  Lazy
//
//  Created by Kiran Kunigiri on 1/30/16.
//  Copyright © 2016 Kiran Kunigiri. All rights reserved.
//

import UIKit

class PaintChart: UIButton {

    var ratio: CGFloat = 0;
    var mode = -1
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if mode == -1 {
            Chart.drawChartMoney(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), ratio: ratio)
        } else {
            Chart.drawChartTrash(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), ratio: ratio)
        }
    }
    
    func switchMode() {
        self.mode *= -1
        setNewRatio(self.ratio)
    }
    
    func setNewRatio(newRatio: CGFloat) {
        self.ratio = newRatio
        self.setNeedsDisplay()
    }

}
