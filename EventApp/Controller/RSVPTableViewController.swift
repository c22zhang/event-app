//
//  RSVPTableViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class RSVPTableViewController: UITableViewController {

    var currentUser: CKRecord?
    var myRSVPdEvents: [CKRecord]?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMyRSVPdEvents()
    }
    
    func loadMyRSVPdEvents() {
        let publicDB = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "RSVP CONTAINS %@", currentUser!.recordID)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (ckRecords: [CKRecord]?, error: Error?) -> Void in
            if let error = error{
                print("\(error)")
                return
            }
            DispatchQueue.main.async{
                self.myRSVPdEvents = ckRecords
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rsvpEvents = myRSVPdEvents{
            return rsvpEvents.count
        }
        else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSVPCell", for: indexPath)
        if let rsvpEvents = myRSVPdEvents{
            let eventName = rsvpEvents[indexPath.row]["Name"] as! String
            let eventDate = (rsvpEvents[indexPath.row]["Date"] as! Date).toString(dateFormat: "MM-dd")
            if let tmp = cell.textLabel{
                tmp.text = eventName
            }
            if let tmp = cell.detailTextLabel{
                tmp.text = eventDate
            }
        }

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyRSVPdToEventDetailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let controller = segue.destination as! EventDetailViewController
                controller.event = myRSVPdEvents![indexPath.row]
                controller.currentUser = self.currentUser
            }
        }
    }
    

}
