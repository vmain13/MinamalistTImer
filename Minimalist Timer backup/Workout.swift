//
//  Workout.swift
//  Optimal Living
//
//  Created by Chris Frerichs on 12/8/17.
//  Copyright © 2017 Chris Frerichs. All rights reserved.
//

import Foundation
import UIKit
import os.log


class Workout: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var exercise: String
    var workPeriod: Int
    var restPeriod: Int
    var reps: Int
    var sets: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "workout name"
        static let exercise = "exercise"
        static let workPeriod = "work period"
        static let restPeriod = "rest period"
        static let reps = "reps"
        static let sets = "sets"
    }
    
    //MARK: Initialization
    
    init?(name: String, exercise: String, workPeriod: Int, restPeriod: Int, reps: Int, sets: Int){
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.exercise = exercise
        self.workPeriod = workPeriod
        self.restPeriod = restPeriod
        self.reps = reps
        self.sets = sets
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(exercise, forKey: PropertyKey.exercise)
        aCoder.encode(workPeriod, forKey: PropertyKey.workPeriod)
        aCoder.encode(restPeriod, forKey: PropertyKey.restPeriod)
        aCoder.encode(reps, forKey: PropertyKey.reps)
        aCoder.encode(sets, forKey: PropertyKey.sets)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let exercise = aDecoder.decodeObject(forKey: PropertyKey.exercise) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let workPeriod = aDecoder.decodeInteger(forKey: PropertyKey.workPeriod)
        
        let restPeriod = aDecoder.decodeInteger(forKey: PropertyKey.restPeriod)
        
        let reps = aDecoder.decodeInteger(forKey: PropertyKey.reps)
        
        let sets = aDecoder.decodeInteger(forKey: PropertyKey.sets)
        
        // Must call designated initializer.
        self.init(name: name, exercise: exercise, workPeriod: workPeriod, restPeriod: restPeriod, reps: reps, sets: sets)
        
    }
}
