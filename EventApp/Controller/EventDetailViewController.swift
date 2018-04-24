//
//  EventDetailViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/22/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit 

class EventDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var event: CKRecord?
    var currentUser: CKRecord?
    var ownedByCurrentUser: Bool?
    
    @IBAction func RSVPAction(_ sender: Any) {
        var references: [CKReference]?
        if let myReferences = event!["RSVP"]{
            references = myReferences as! [CKReference]
            let newReference = CKReference(recordID: currentUser!.recordID, action: .none)
            if !references!.contains(newReference){
                references!.append(newReference)
            }
            event!["RSVP"] = references! as CKRecordValue
        }
        else{
            references = []
            references!.append(CKReference(recordID: currentUser!.recordID, action: .none))
            event!["RSVP"] = references! as CKRecordValue
        }
        CKUtils.getPublicDatabase().save(event!) { (record: CKRecord?, error: Error?) in
            if CKUtils.handleError(error, "An error occurred while saving your RSVP", nil){
                return
            }
            self.event = record
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = self.event{
            nameLabel.text = event["Name"] as? String
            locationLabel.text = event["Location"] as? String
            timeLabel.text = event["Time"] as? String
            dateLabel.text = (event["Date"] as? Date)?.toString(dateFormat: "MM-dd")
            costLabel.text = event["Cost"] as? String
            
            descriptionText.text = event["Description"] as? String
            descriptionText.isEditable = false
            
            let creator: CKReference = event["Creator"] as! CKReference
            creatorLabel.text = CKUtils.getFromID(reference: creator, database: CKUtils.getPrivateDatabase())!["Username"] as? String
            
            if isOwner(){
                deleteButton.isEnabled = true
            }
            else{
                deleteButton.isEnabled = false
              deleteButton.setTitleColor(UIColor.lightGray, for: .disabled)
            }
        }
    }
    
    func isOwner() -> Bool{
        let creator = event!["Creator"] as! CKReference
        let creatorRecord = CKUtils.getFromID(reference: creator, database: CKUtils.getPrivateDatabase())
        return creatorRecord!.recordID == currentUser!.recordID
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoingToEventSegue"{
            let controller = segue.destination as! GoingTableViewController
            controller.event = self.event
        }
        else if segue.identifier == "GetCommentsSegue"{
            let controller = segue.destination as! CommentsTableViewController
            controller.event = self.event
            controller.currentUser = self.currentUser
        }
    }
    

}
