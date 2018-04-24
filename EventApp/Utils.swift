//
//  Utils.swift
//  Helpful utility functions that can simplify the code in the actual application
//  EventApp
//
//  Created by Christopher Zhang on 4/24/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import Foundation
import CloudKit

/*
 Handy date to String extension from
 https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift
 */
public extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

public class CKUtils {
    
    //returns the default public database
    public static func getPublicDatabase() -> CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }
    
    //returns the default private database
    public static func getPrivateDatabase() -> CKDatabase {
        return CKContainer.default().privateCloudDatabase
    }
    
    //gets a record from a given reference ID if it exists in the given database
    public static func getFromID(reference: CKReference, database: CKDatabase) -> CKRecord? {
        var creator: CKRecord?
        let id = reference.recordID
        let fetchGroup = DispatchGroup()
        fetchGroup.enter()
        DispatchQueue.global().async{
            database.fetch(withRecordID: id){ (record: CKRecord?, error: Error?) -> Void in
                if handleError(error, "An error occurred when fetching the record: ", fetchGroup){
                    return
                }
                else{
                    creator = record
                    fetchGroup.leave()
                    return
                }
            }
        }
        fetchGroup.wait()
        return creator
    }
    
    //shortens the annoying error checking the needs to occur when doing operations on cloud databases
    public static func handleError(_ error: Error?, _ message: String, _ dispatcher: DispatchGroup?) -> Bool{
        if let error = error{
            print("\(message) \(error)")
            if let dispatcher = dispatcher{
                dispatcher.leave()
            }
            return true
        }
        return false
    
    }
}


