//
//  WorkViewController.swift
//  Optimal Living
//
//  Created by Chris Frerichs on 12/9/17.
//  Copyright © 2017 Chris Frerichs. All rights reserved.

import AVFoundation
import Foundation
import UIKit
import os.log

class WorkViewController: UIViewController{

    @IBAction func dismissLoader() {
        if (self.presentingViewController != nil){
            self.dismiss(animated: true, completion: nil)
        }
        exited = true
    }

    //MARK: UI Elements
    
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    
    // whether timer is active
    var exited = false
    
    var workPeriodTime: Int = 0
    var restPeriodTime: Int = 0
    var workRestIterations: Int = 0
    var exercise: String = ""
    var workout: Workout?
    
    var seconds = 0
    var rest = 0
    // all work outs start with zero sets
    var sets = 0
    var totalSets = 0
    
    var workingTimer = Timer()
    var restingTimer = Timer()
    var workTimerOn = false
    var restTimerOn = false
    // which state has been paused
    var restPause = false
    var workPause = false
    
    // pause vs. resume
    var resumeTapped = false
    
    // Work or Rest Complete Beep
    let systemSoundID: SystemSoundID = 1052
    
    // show exercise name
    
    //MARK: - IBactions
    @IBAction func startButtonTapped(_ sender: Any) {
        // avoid creating multiple timer instances
        if workTimerOn == false {
            runTimer()
        }
    }
    func runTimer(){
        if exited == false{
            if workPause == false {
                seconds = workPeriodTime + 1
            }
            workingTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: (#selector(WorkViewController.updateTimer)), userInfo: nil, repeats: true)
            workTimerOn = true
            workPause = false
        }
    }
    func restTimer(){
        if exited == false{
            if restPause == false {
                rest = restPeriodTime + 1
            }
            restingTimer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: (#selector(WorkViewController.updaterestTimer)), userInfo: nil, repeats: true)
            restTimerOn = true
            restPause = false
        }
    }
    //work
    @objc func updateTimer() {
        if exited == false{
            if seconds < 1 {
                AudioServicesPlaySystemSound (systemSoundID)
                workingTimer.invalidate()
                restTimer()
                workTimerOn = false
                sets += 1
                //display sets completed/remaining
                setLabel.text = String("\(sets) / \(totalSets)")
                if sets == totalSets{
                    self.dismissLoader()
                }
                
            } else {
                seconds -= 1
                workLabel.text = timeString(time:TimeInterval(seconds))
                //display sets completed/remaining
                setLabel.text = String("\(sets) / \(totalSets)")
            }
        }
    }
    //Rest
    @objc func updaterestTimer() {
        if exited == false{
            if rest < 1 {
                AudioServicesPlaySystemSound (systemSoundID)
                restingTimer.invalidate()
                runTimer()
                restTimerOn = false
            } else {
                rest -= 1
                restLabel.text =
                timeString(time:TimeInterval(rest))
        }
        }
    }
    
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        // if pause has not been tapped previously
        if self.resumeTapped == false {
            // stop timer without resetting the current value of seconds
            if workTimerOn == true{
                workingTimer.invalidate()
                self.pauseButton.setTitle("Resume", for: .normal)
                // paused during a work period
                workPause = true
            } else if restTimerOn == true{
                restingTimer.invalidate()
                // paused during a rest period
                self.pauseButton.setTitle("Resume", for: .normal)
                restPause = true
            }
            self.resumeTapped = true
        } else {
            if workPause == true{
                runTimer()
            } else if restPause == true{
                restTimer()
            }
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
        }
    }

    @IBAction func resetButtonTapped(_ sender: Any) {
        if workTimerOn == true{
            workingTimer.invalidate()
            seconds = workPeriodTime
            workLabel.text = timeString(time:TimeInterval(seconds))
            workTimerOn = false
        } else if restTimerOn == true{
            restingTimer.invalidate()
            rest = 0
            restLabel.text = timeString(time:TimeInterval(rest))
            restTimerOn = false
        }
    }

    func timeString(time:TimeInterval) -> String{
        let minutes = Int(time)/60 % 60
        let seconds = Int(time)%60
        return String(format:"%02i:%02i",minutes, seconds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let workout = workout {
            workPeriodTime = workout.workPeriod
            restPeriodTime = workout.restPeriod
            exercise = workout.exercise
            totalSets = workout.sets
        }
            //display current exercise
            exerciseLabel.text = exercise
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




