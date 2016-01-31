//
//  ViewController.swift
//  Lazy
//
//  Created by Kiran Kunigiri on 1/30/16.
//  Copyright © 2016 Kiran Kunigiri. All rights reserved.
//

import UIKit
import C4
import Firebase

class HomeViewController: UIViewController {
    
    // Connection
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var chartButton: PaintChart!
    @IBOutlet var motivateButton: PaintMotivate!
    @IBOutlet var motivateLabel: UILabel!
    @IBOutlet var motivateView: UIView!
    var motivateView2: C4View!
    var blurView: UIVisualEffectView!
    
    // Properties
    var loading = true
    var workTimer: Stopwatch!
    var wasteTimer: Stopwatch!
    var mode = -1
    let kWorkMode = -1
    let kWasteMode = 1
    var motivateState = -1
    
    var oldWorkTime: NSTimeInterval!
    var oldWasteTime: NSTimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFirstTimer()
        
        motivateView2 = C4View(view: motivateView)
        motivateView2.size = C4Size(200, 200)
        motivateView2.border.radius = 10
        
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        blurView.alpha = 0
        
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            C4ViewAnimation(duration: 0.25) {
                self.motivateView2.opacity = 0
                self.blurView.alpha = 0
                }.animate()
            
        }
    }

func loadFirstTimer() {
    myRootRef.childByAppendingPath("workTime").observeEventType(.Value, withBlock: { snapshot in
        self.oldWorkTime = (snapshot.value as! NSDictionary).valueForKeyPath("totalTime") as! NSTimeInterval
        self.loadSecondTimer()
        
        }, withCancelBlock: { error in
            print("error")
    })
}

func loadSecondTimer() {
    myRootRef.childByAppendingPath("wasteTime").observeEventType(.Value, withBlock: { snapshot in
        self.oldWasteTime = (snapshot.value as! NSDictionary).valueForKeyPath("totalTime") as! NSTimeInterval
        
        self.wasteTimer = Stopwatch(closure: { () -> (Void) in
            if !self.loading {
                let first = CGFloat(self.wasteTimer.getTimeInMilliseconds() + self.oldWasteTime)
                let second = first + CGFloat(self.workTimer.getTimeInMilliseconds() + self.oldWorkTime)
                self.chartButton.setNewRatio(first/second)
                self.timeLabel.text = Converter.toStringDisplay(CGFloat(self.wasteTimer.getTimeInMilliseconds() + self.oldWasteTime))
            }
        })
        
        self.workTimer = Stopwatch(
            closure: { () -> (Void) in
                if !self.loading {
                    let first = CGFloat(self.wasteTimer.getTimeInMilliseconds() + self.oldWasteTime)
                    let second = first + CGFloat(self.workTimer.getTimeInMilliseconds() + self.oldWorkTime)
                    self.chartButton.setNewRatio(first/second)
                    self.timeLabel.text = Converter.toStringDisplay(CGFloat(self.workTimer.getTimeInMilliseconds() + self.oldWorkTime))
                }
        })
        
        self.workTimer.start()
        self.loading = false
        
        }, withCancelBlock: { error in
            print("error")
    })
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


@IBAction func chartButtonPressed(sender: UIButton) {
    if loading {
        return
    } else {
        
        mode *= -1
        chartButton.switchMode()
        
        if mode == kWorkMode {
            wasteTimer.pause()
            workTimer.start()
        }
        if mode == kWasteMode {
            workTimer.pause()
            wasteTimer.start()
        }
        updateFirebase()
    }
}
    
    func updateFirebase() {
        myRootRef.childByAppendingPath("workTime").childByAppendingPath("totalTime").setValue(self.workTimer.getTimeInMilliseconds() + self.oldWorkTime)
        myRootRef.childByAppendingPath("wasteTime").childByAppendingPath("totalTime").setValue(self.wasteTimer.getTimeInMilliseconds() + self.oldWasteTime)
        loadFirstTimer()
    }

@IBAction func motivateButtonPressed(sender: UIButton) {
    if motivateState == -1 {
        canvas.add(blurView)
        canvas.add(motivateView2)
        C4ViewAnimation(duration: 0.25) {
            self.motivateView2.center = self.canvas.center
            self.motivateView2.opacity = 1
            self.blurView.alpha = 1
            }.animate()
    }
    if motivateState == 1 {
        //            canvas.add(blur)
    }
    
    motivateState *= -1
}



}








