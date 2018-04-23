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
    
    @IBAction func RSVPAction(_ sender: Any) {
    }
    
    var event: CKRecord?
    
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
            creatorLabel.text = EventDetailViewController.getCreatorFromID(reference: creator)!["Username"] as? String
        }
    }
    
    static func getCreatorFromID(reference: CKReference) -> CKRecord? {
        var creator: CKRecord?
        let id = reference.recordID
        let privateDB = CKContainer.default().privateCloudDatabase
        let fetchGroup = DispatchGroup()
        fetchGroup.enter()
        DispatchQueue.global().async{
            privateDB.fetch(withRecordID: id){ (record: CKRecord?, error: Error?) -> Void in
                if let error = error{
                    print("An error occurred when fetching the record: \(error)")
                    fetchGroup.leave()
                    return
                }
                else{
                    creator = record
                    fetchGroup.leave()
                    return
                }
            }
        }
        fetchGroup.wait()
        return creator
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ""{
            
        }
    }
    

}