//
//  MyEventsTableViewController.swift
//  EventApp
//  View where users can view the events they are hosting
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class MyEventsTableViewController: UITableViewController {

    var currentUser: CKRecord?
    var myEvents: [CKRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveMyEvents()
    }

    func retrieveMyEvents(){
        let predicate = NSPredicate(format: "Creator = %@", currentUser!.recordID)
        let query = CKQuery(recordType: "Event", predicate: predicate)
        CKUtils.getPublicDatabase().perform(query, inZoneWith: nil) { (ckRecords: [CKRecord]?, error: Error?) in
            if CKUtils.handleError(error, "Error while retrieving events", nil){
                return
            }
            DispatchQueue.main.async{
                self.myEvents = ckRecords
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let myEvents = self.myEvents{
            return myEvents.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath)
        if let myEvents = self.myEvents{
            let name = myEvents[indexPath.row]["Name"] as! String
            let date = (myEvents[indexPath.row]["Date"] as! Date).toString(dateFormat: "MM-dd")
            if let tmp = cell.textLabel{
                tmp.text = name
            }
            if let tmp = cell.detailTextLabel{
                tmp.text = date
            }
        }
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyEventsToEventsDetailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let controller = segue.destination as! EventDetailViewController
                controller.event = myEvents![indexPath.row]
                controller.currentUser = self.currentUser
            }
        }
    }
    

}
