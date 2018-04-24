//
//  CreateEventsViewController.swift
//  EventApp
//
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
    
    var currentUser: CKRecord?
    var events: [CKRecord]?
    var newEventDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        print("There are necessary fields that were left empty or invalid.")
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
            self.dateButton.setTitle(self.newEventDate!.toString(dateFormat: "MM-dd HH:mm"), for: .normal)
        }
    }
}
