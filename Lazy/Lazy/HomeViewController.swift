//
//  ViewController.swift
//  Lazy
//
//  Created by Kiran Kunigiri on 1/30/16.
//  Copyright © 2016 Kiran Kunigiri. All rights reserved.
//

import UIKit
import C4

class HomeViewController: UIViewController {

    // Connection
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var chartView: PaintChart!
    @IBOutlet var motivateButton: PaintMotivate!
    @IBOutlet var motivateLabel: UILabel!
    
    // Properties
    var ratio: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let inner = C4Circle(center: C4Point(canvas.center.x, canvas.center.y + 20), radius: (canvas.width - 130)/2)
//        inner.fillColor = C4Color.init(UIColor(red:0.200, green:0.286, blue:0.365, alpha:1))
//        inner.lineWidth = 15
//        inner.strokeColor = C4Color.init(UIColor(red:0.102, green:0.737, blue:0.612, alpha:1))
//        inner.interactionEnabled = false
//        
//        canvas.add(inner)
//        canvas.sendToBack(inner)

        NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "animate", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animate() {
        chartView.setNewRatio(ratio + 0.05)
        chartView.setNeedsDisplay()
        ratio += 0.001
    }
    
    @IBAction func motivateButtonPressed(sender: UIButton) {
        print("Pressed motivate button")
    }
    


}