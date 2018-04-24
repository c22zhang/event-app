//
//  OptionsViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class OptionsViewController: UIViewController {
    
    var events: [CKRecord]?
    var currentUser: CKRecord?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "CreateEventsSegue":
            let controller = segue.destination as! CreateEventsViewController
            controller.currentUser = self.currentUser
            controller.events = self.events
        case "MyEventsSegue":
            print("MyEventsSegue")
        case "AccountInfoSegue":
            let controller = segue.destination as! ChangeAccountViewController
            controller.currentUser = self.currentUser
        case "RSVPTableViewSegue":
            print("RSVPTableViewSegue")
        default:
            break 
        }
    }

}
