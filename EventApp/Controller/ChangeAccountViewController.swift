//
//  ChangeAccountViewController.swift
//  EventApp
//  View where users can change their account info 
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class ChangeAccountViewController: UIViewController {

    var currentUser: CKRecord?
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editUserData() -> CKRecord?{
        if let name = nameText.text{
            currentUser!["Name"] = name as CKRecordValue
        }
        if let age = ageText.text{
            if let intAge = Int(age){
                currentUser!["Age"] = intAge as CKRecordValue
            }
        }
        if let password = passwordText.text{
            currentUser!["Password"] = password as CKRecordValue
        }
        if let email = emailText.text{
            currentUser!["Email"] = email as CKRecordValue
        }
        return currentUser
    }
}
