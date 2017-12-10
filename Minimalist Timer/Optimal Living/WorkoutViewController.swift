//
//  WorkoutViewController.swift
//  Optimal Living
//
//  Created by Chris Frerichs on 12/8/17.
//  Copyright © 2017 Chris Frerichs. All rights reserved.
//

import Foundation

import UIKit
import os.log

class WorkoutViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var workPeriodTextField: UITextField!
    @IBOutlet weak var restPeriodTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    /*
     This value is either passed by `WorkoutTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new workout.
     */
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Workout"
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        // set bar text and font color
        bar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor.black]
        // set nav bar title color
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        // set nav bar right button color
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        // Declare font
        let font = UIFont(name: "HelveticaNeue", size: 15.0)
        // Set navigation button fonts
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: [])
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: [])
        // Set text box colors
        
        nameTextField.layer.borderWidth = 0.01
        exerciseTextField.layer.borderWidth = 0.01
        
        
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        exerciseTextField.delegate = self
        workPeriodTextField.delegate = self
        restPeriodTextField.delegate = self
        repsTextField.delegate = self
        setsTextField.delegate = self
        
        // Set up views if editing an existing Workout.
        if let workout = workout {
            navigationItem.title = workout.name
            nameTextField.text = workout.name
            exerciseTextField.text = workout.exercise
            workPeriodTextField.text = String(workout.workPeriod)
            restPeriodTextField.text = String(workout.restPeriod)
            repsTextField.text = String(describing: workout.reps)
            setsTextField.text = String(describing: workout.sets)
        }
        
        // Enable the Save button only if the text field has a valid Workout name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    

    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddWorkoutMode = presentingViewController is UINavigationController
        
        if isPresentingInAddWorkoutMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The WorkoutViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text
        let exercise = exerciseTextField.text
        let workPeriod = Int(workPeriodTextField.text!)
        let restPeriod = Int(restPeriodTextField.text!)
        let reps = Int(repsTextField.text!)
        let sets = Int(setsTextField.text!)
        
        // Set the workout to be passed to WorkoutTableViewController after the unwind segue.
        workout = Workout(name: name!, exercise: exercise!, workPeriod: workPeriod!, restPeriod: restPeriod!, reps: reps!, sets: sets!)
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        let text1 = exerciseTextField.text ?? ""
        let text2 = workPeriodTextField.text ?? ""
        let text3 = restPeriodTextField.text ?? ""
        let text4 = repsTextField.text ?? ""
        let text5 = setsTextField.text ?? ""
        
        saveButton.isEnabled = (!text.isEmpty && !text1.isEmpty && !text2.isEmpty && !text3.isEmpty && !text4.isEmpty && !text5.isEmpty)
    }
}
