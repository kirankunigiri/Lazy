//
//  PaintMotivateButton.swift
//  Lazy
//
//  Created by Kiran Kunigiri on 1/30/16.
//  Copyright © 2016 Kiran Kunigiri. All rights reserved.
//

import UIKit

class PaintMotivate: UIButton {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        Chart.drawMotivate(frame: CGRectMake(0, 0, 50, 50))
    }

}
