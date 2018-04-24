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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = ""
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
                        return
                    }
                })
            }
        }
    }

}
