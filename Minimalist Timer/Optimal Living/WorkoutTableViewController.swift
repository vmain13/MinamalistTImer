//
//  WorkoutTableViewController.swift
//  Optimal Living
//
//  Created by Chris Frerichs on 12/8/17.
//  Copyright © 2017 Chris Frerichs. All rights reserved.
//

import Foundation
import UIKit
import os.log

class WorkoutTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var workouts = [Workout]()
    var rowName = 0
    // Initialize strings
    var reps = ""
    var sets = ""
    var work = ""
    var rest = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    
        // Load any saved workouts, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        }
        else {
            // Load the sample data.
            loadSampleWorkouts()
        }
        // set nav bar right button color
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        // Declare font
        let font = UIFont(name: "HelveticaNeue", size: 15.0)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: font!], for: [])
        
        // set nav bar right button font
        // transparent navigation bar
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        self.title = "Your Workouts"
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.alpha = 0.0
        // set bar text font and color
        bar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 20)!, NSAttributedStringKey.foregroundColor:UIColor.white]
        
        // set nav bar title color
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkoutTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutTableViewCell.")
        }
        
        // Fetches the appropriate workout for the data source layout.
        let workout = workouts[indexPath.row]
        
        // Change labels number of Lines
        cell.repsLabel.numberOfLines = 0
        cell.setsLabel.numberOfLines = 0
        cell.workPeriodLabel.numberOfLines = 0
        cell.restPeriodLabel.numberOfLines = 0
        
        cell.nameLabel.text = workout.name
        cell.exerciseLabel.text = workout.exercise
        work = String(describing: workout.workPeriod)
        rest = String(describing: workout.restPeriod)
        reps = String(describing: workout.reps)
        sets = String(describing: workout.sets)
        cell.workPeriodLabel.text = String("Work\n\(work)")
        cell.restPeriodLabel.text = String("Rest\n\(rest)")
        cell.repsLabel.text = String("Reps\n\(reps)")
        cell.setsLabel.text = String("Sets\n\(sets)")
//        cell.goButton.tag = indexPath.row
//        cell.goButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
         return cell
    }
    
    
    @objc func buttonClicked(sender: UIButton) {
        self.rowName = sender.tag
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            workouts.remove(at: indexPath.row)
            saveWorkouts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
     // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tomove = workouts[sourceIndexPath.row]
        workouts.remove(at: sourceIndexPath.row)
        workouts.insert(tomove, at: destinationIndexPath.row)
        saveWorkouts()
    }
    
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
    
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new workout.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let workoutDetailViewController = segue.destination as? WorkViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedWorkoutCell = sender as? WorkoutTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedWorkoutCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedWorkout = workouts[indexPath.row]
            
            workoutDetailViewController.workout = selectedWorkout
            
//        case "putInWork":
//
//            guard let WorkViewController = segue.destination as? WorkViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            guard let selectedWorkoutCell = sender as? WorkoutTableViewCell else {
//                fatalError("Unexpected sender: \(String(describing: sender))")
//            }
            
//            guard let indexPath = tableView.indexPath(for: selectedWorkoutCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
                //let selectedWorkout = workouts[indexPath.row]
//            WorkDetailViewController.workout = selectedWorkout
            
//            let selectedWorkout = workouts[self.rowName]
//            Work1ViewController.workout = selectedWorkout
//
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
   
    
    //MARK: Actions
    
    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let source = sender.source as? WorkoutViewController, let workout = source.workout {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing workout.
                workouts[selectedIndexPath.row] = workout
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new workout.
                let newIndexPath = IndexPath(row: workouts.count, section: 0)
                
                workouts.append(workout)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the Workouts.
            saveWorkouts()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleWorkouts() {
        
        guard let workout1 = Workout(name: "Tabata", exercise: "Slay", workPeriod: 20, restPeriod: 10, reps: 20, sets: 10) else {
            fatalError("Unable to instantiate workout1")
        }
        // Insert into array
        workouts += [workout1]
    }
    
    private func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save workouts...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadWorkouts() -> [Workout]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Workout.ArchiveURL.path) as? [Workout]
    }
    
}
