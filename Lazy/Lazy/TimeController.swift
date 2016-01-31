//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by Kiran Kunigiri on 10/15/15.
//  Copyright © 2015 Kiran Kunigiri. All rights reserved.
//

import Foundation
import UIKit
import Darwin

// MARK: Stopwatch
class Stopwatch: NSObject {
    
    // Timer
    private var timer = NSTimer()
    
    // MARK: Time in a string
    /**
    String representation of the number of hours shown on the stopwatch
    */
    var strHours = "00"
    /**
     String representation of the number of minutes shown on the stopwatch
     */
    var strMinutes = "00"
    /**
     String representation of the number of seconds shown on the stopwatch
     */
    var strSeconds = "00"
    /**
     String representation of the number of tenths of a second shown on the stopwatch
     */
    var strTenthsOfSecond = "00"
    /**
     String representation text shown on the stopwatch (the time)
     */
    var timeText = ""
    
    // MARK: Time in values
    /**
    The number of hours that will be shown on a stopwatch
    */
    var numHours = 0
    /**
     The number of minutes that will be shown on a stopwatch
     */
    var numMinutes = 0
    /**
     The number of seconds that will be shown on a stopwatch
     */
    var numSeconds = 0
    /**
     The number of tenths of a second that will be shown on a stopwatch
     */
    var numTenthsOfSecond = 0
    
    var numMillSeconds: NSTimeInterval = 0
    
    /**
    The function to be run at every millisecond that the timer updates
    */
    var updateMethod: () -> (Void)
    
    // Private variables
    public var startTime = NSTimeInterval()
    private var wasPause = false
    
    init(closure: () -> (Void)) {
        self.updateMethod = closure
    }
    
    /**
     Updates the time and saves the values as strings
     */
     @objc private func updateTime() {
        // Save the current time
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        // Find the difference between current time and start time to get the time elapsed
        var elapsedTime: NSTimeInterval = currentTime - startTime
        numMillSeconds = elapsedTime
//        print(numMillSeconds)
        
        // Calculate the hours of elapsed time
        numHours = Int(elapsedTime / 3600.0)
        elapsedTime -= (NSTimeInterval(numHours) * 3600)
        
        // Calculate the minutes of elapsed time
        numMinutes = Int(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(numMinutes) * 60)
        
        // Calculate the seconds of elapsed time
        numSeconds = Int(elapsedTime)
        elapsedTime -= NSTimeInterval(numSeconds)
        
        // Finds out the number of milliseconds to be displayed.
        numTenthsOfSecond = Int(elapsedTime * 100)
        
        // Save the values into strings with the 00 format
        strHours = String(format: "%02d", numHours)
        strMinutes = String(format: "%02d", numMinutes)
        strSeconds = String(format: "%02d", numSeconds)
        strTenthsOfSecond = String(format: "%02d", numTenthsOfSecond)
        timeText = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
        
        updateMethod()
    }
    
    
    // MARK: Public functions
    private func resetTimer() {
        startTime = NSDate.timeIntervalSinceReferenceDate()
        strHours = "00"
        strMinutes = "00"
        strSeconds = "00"
        strTenthsOfSecond = "00"
        timeText = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
    }
    
    /**
     Starts the stopwatch, or resumes it if it was paused
     */
    func start() {
        if !timer.valid {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            
            if wasPause {
                startTime = NSDate.timeIntervalSinceReferenceDate() - startTime
            } else {
                startTime = NSDate.timeIntervalSinceReferenceDate()
            }
        }
    }
    
    /**
     Pause the stopwatch so that it can be resumed later
     */
    func pause() {
        wasPause = true
        
        timer.invalidate()
        let pauseTime = NSDate.timeIntervalSinceReferenceDate()
        startTime = pauseTime - startTime
    }
    
    /**
     Stops the stopwatch and erases the current time
     */
    func stop() {
        wasPause = false
        
        timer.invalidate()
        resetTimer()
    }
    
    
    // MARK: Value functions
    
    /**
    Converts the time into hours only and returns it
    */
    func getTimeInHours() -> Int {
        return numHours
    }
    
    /**
     Converts the time into minutes only and returns it
     */
    func getTimeInMinutes() -> Int {
        return numHours * 60 + numMinutes
    }
    
    /**
     Converts the time into seconds only and returns it
     */
    func getTimeInSeconds() -> Int {
        return numHours * 3600 + numMinutes * 60 + numSeconds
    }
    
    /**
     Converts the time into milliseconds only and returns it
     */
    func getTimeInMilliseconds() -> NSTimeInterval {
        print(numMillSeconds)
        return numMillSeconds
    }
    
}


class Converter {
    
    class func toStringDisplay(newTime: CGFloat) -> String {
        // Find the difference between current time and start time to get the time elapsed
        var elapsedTime: NSTimeInterval = NSTimeInterval(newTime)
        
        // Calculate the hours of elapsed time
        let numHours = Int(elapsedTime / 3600.0)
        elapsedTime -= (NSTimeInterval(numHours) * 3600)
        
        // Calculate the minutes of elapsed time
        let numMinutes = Int(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(numMinutes) * 60)
        
        // Calculate the seconds of elapsed time
        let numSeconds = Int(elapsedTime)
        elapsedTime -= NSTimeInterval(numSeconds)
        
        // Finds out the number of milliseconds to be displayed.
        let numTenthsOfSecond = Int(elapsedTime * 100)
        
        if (numMinutes < 1) {
            return String(numSeconds)
        }
        if (numHours < 1) {
            let seconds = String(format: "%02d", numSeconds)
            return "\(numMinutes):\(seconds)"
        }
        let minutes = String(format: "%02d", numMinutes)
        return "\(numHours):\(minutes)"
    }
    
}

// MARK: LabelStopwatch

/**
* Subclass of Stopwatch
*
* This class automatically updates any UILabel wih the stopwatch time.
* This makes it easier to use the stopwatch. All you have to do is create a
* LabelStopwatch and pass in your UILabel as the parameter. Then the LabelStopwatch
* will automatically update your label as you call the start, stop, or reset functions.
*/

class LabelStopwatch: Stopwatch {
    
    /**
     The label that will automatically be updated according to the stopwatch
     */
    var label = UILabel()
    
    /**
     Creates a stopwatch with a label that it will constantly update
     */
    init(label: UILabel, closure: () -> (Void)) {
        super.init(closure: closure)
        self.label = label
    }
    
    override internal func updateTime() {
        super.updateTime()
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        label.text = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
    }
    
    override private func resetTimer() {
        super.resetTimer()
        label.text = "\(strHours):\(strMinutes):\(strSeconds):\(strTenthsOfSecond)"
    }
    
}






