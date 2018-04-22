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
    

}
