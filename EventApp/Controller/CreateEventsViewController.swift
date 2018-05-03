//
//  CreateEventsViewController.swift
//  EventApp
//  View where users can create events
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class CreateEventsViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var costText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var message: UILabel!
    
    var currentUser: CKRecord?
    var events: [CKRecord]?
    var newEventDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.message.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createNewEvent() -> CKRecord?{
        let event = CKRecord(recordType: "Event")
        if hasAllRequiredFields(){
            if let cost = Double(costText.text!){
                event["Description"] = descriptionText.text! as CKRecordValue
                event["Date"] = newEventDate! as CKRecordValue
                event["Time"] = timeText.text! as CKRecordValue
                event["Cost"] = cost as CKRecordValue
                event["Name"] = nameText.text! as CKRecordValue
                event.setObject(CKReference(record: self.currentUser!, action: .deleteSelf) as CKRecordValue, forKey: "Creator")
                print(event)
                return event
            }
        }
        return nil
    }
    
    private func hasAllRequiredFields() -> Bool{
        return nameText.text != nil
            && timeText.text != nil
            && locationText.text != nil
            && costText.text != nil
            && descriptionText.text != nil
            && newEventDate != nil 
    }
    
    // MARK: - Navigation

    @IBAction func unwindDateSelector(_ unwindSegue: UIStoryboardSegue){
        if let source = unwindSegue.source as? DateSelectorViewController{
            self.newEventDate = source.getDate()
            self.dateButton.setTitle(self.newEventDate!.toString(dateFormat: "MM-dd"), for: .normal)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "PickDateSegue"{
            return true
        }
        else{
            if !hasAllRequiredFields(){
                self.present(CKUtils.createAlert("Missing required fields!", "All of the fields are required to create a new account. Please fill them in with the appropriate info."), animated: true, completion: nil)
                self.message.text = "Missing required fields!"
            }
            else{
                self.message.text = ""
            }
            return hasAllRequiredFields()
        }
    }
}
