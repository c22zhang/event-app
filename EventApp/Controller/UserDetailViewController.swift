//
//  UserDetailViewController.swift
//  EventApp
//  View that displays details about a user
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var describingUser: CKRecord?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = self.describingUser{
            if let username = user["Username"] as? String{
                usernameLabel.text = username
            }
            if let name = user["Name"] as? String{
                nameLabel.text = name
            }
            if let age = user["Age"] as? String{
                ageLabel.text = age
            }
            if let email = user["Email"] as? String{
                emailLabel.text = email
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
