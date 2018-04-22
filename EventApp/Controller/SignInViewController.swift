//
//  SignInViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/21/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class SignInViewController: UIViewController {

    var user: CKRecord?
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getUserFromDB(_ username: String ){
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "%K == %@", "Username", username)
        let query = CKQuery(recordType: "AppUser", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) -> Void in
            if let error = error{
                print("An error occurred: \(error)")
                return
            }
            else if (records!.count == 0) || (records!.count > 1){
                print("Error authenticating user")
                return
            }
            else{
                self.user = records![0]
            }
        }
    }
    
    private func verifyTextFields() -> (username: String?, password: String?){
        guard let user = userNameText.text else {
            print("No username")
            return (nil, nil)
        }
        guard let password = passwordText.text else{
            print("No password")
            return (nil, nil)
        }
        return(user, password)
    }
    
    private func canLogIn() -> Bool {
        let userTuple = verifyTextFields()
        if userTuple.username != nil && userTuple.password != nil{
            getUserFromDB(userTuple.username!)
            if let currentUser = self.user {
                if currentUser["Password"] as? String == userTuple.password{
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "LoginSegue"{
            return canLogIn()
        }
        else{
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue"{
            let controller = segue.destination as! MainEventsTableViewController
            controller.currentUser = self.user
        }
    }

}
