//
//  SignInViewController.swift
//  EventApp
//  
//  Screen where users can sign in
//  Created by Christopher Zhang on 4/21/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class SignInViewController: UIViewController {

    var user: CKRecord?
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = ""
        CKContainer.default().accountStatus { accountStatus, error in
            //Check if user is logged in to iCloud - required for CloudKit
            //Code from Apple CloudKit documentation
            if accountStatus == .noAccount {
                let alert = CKUtils.createAlert("Sign in to iCloud", "Sign in to your iCloud account to use the application. On the Home screen, launch Settings, tap iCloud or select 'Sign into your iPhone', and enter your Apple ID.")
                self.present(alert, animated: true, completion: nil)
                self.message.text = "Please sign in to iCloud"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getUserFromDB(_ username: String ){
        let predicate = NSPredicate(format: "%K == %@", "Username", username)
        let query = CKQuery(recordType: "AppUser", predicate: predicate)
        let queryGroup = DispatchGroup()
        queryGroup.enter()
        DispatchQueue.global().async{
            CKUtils.getPrivateDatabase().perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) -> Void in
                if CKUtils.handleError(error, "An error occurred when checking the database: ", queryGroup){
                    return
                }
                else if (records!.count == 0) || (records!.count > 1){
                    self.message.text = "User doesn't exist."
                    queryGroup.leave()
                    return
                }
                else{
                    self.user = records![0]
                    queryGroup.leave()
                }
            }
        }
        queryGroup.wait()
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
        }
        if let currentUser = self.user{
            if currentUser["Password"] as? String == userTuple.password
                && currentUser["Username"] as? String == userTuple.username {
                self.message.text = ""
                return true
            }
        }
        self.message.text = "Invalid username or password."
        let alert = CKUtils.createAlert("Could not log in.", "Invalid username or password")
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func unwindNewUser(_ unwindSegue: UIStoryboardSegue){
        if let signupController = unwindSegue.source as? SignUpViewController{
            let record = signupController.createNewUser()
            if let newRecord = record{
                CKUtils.getPrivateDatabase().save(newRecord, completionHandler: { (ckRecord: CKRecord?, error: Error?) -> Void in
                    if CKUtils.handleError(error, "An error occurred when creating a new user: ", nil){
                        DispatchQueue.main.async{
                            self.present(CKUtils.createAlert("Error", "Could not create new user - maybe you were missing some fields in the sign in menu?"), animated: true, completion: nil)
                        }
                        return
                    }
                })
            }
        }
    }

}
