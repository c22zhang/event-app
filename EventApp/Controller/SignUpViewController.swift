//
//  SignUpViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/21/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewUser() -> CKRecord? {
        guard let username = userNameText.text else{
            return nil
        }
        guard let password = passwordText.text else{
            return nil
        }
        guard let name = nameText.text else{
            return nil
        }
        guard let age = Int(ageText.text!) else{
            return nil
        }
        guard let email = emailText.text else{
            return nil
        }
        
        let newRecord = CKRecord(recordType: "AppUser")
        newRecord["Username"] = username as CKRecordValue
        newRecord["Password"] = password as CKRecordValue
        newRecord["Name"] = name as CKRecordValue
        newRecord["Age"] = age as CKRecordValue
        newRecord["Email"] = email as CKRecordValue
        
        return newRecord
    }
    
    private func determineDuplicateUser() -> Bool?{
        var shouldSegue: Bool?
        let queryGroup = DispatchGroup()
        queryGroup.enter()
        if let username = userNameText.text{
            let privateDB = CKContainer.default().privateCloudDatabase
            let predicate = NSPredicate(format: "%K == %@", "Username", username)
            let query = CKQuery(recordType: "AppUser", predicate: predicate)
            DispatchQueue.global().async{
                privateDB.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) -> Void in
                    if let error = error{
                        print("An error occurred: \(error)")
                        shouldSegue = false
                        queryGroup.leave()
                        return
                    }
                    else if records!.count > 0{
                        print("User already exists")
                        shouldSegue = false
                        queryGroup.leave()
                        return
                    }
                    else{
                        shouldSegue = true
                        queryGroup.leave()
                        return
                    }
                }
            }
        }
        //there's currently a bit of delay with the Dispatch queues as the username is authenticated
        //something to do in the future is to add some notifications/progress bar to make this more user friendly
        queryGroup.wait()
        return shouldSegue
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //this is a terrible way to deal with asynchronous function calls but works for now
        //sleep(2)
        return determineDuplicateUser()!
    }
}
