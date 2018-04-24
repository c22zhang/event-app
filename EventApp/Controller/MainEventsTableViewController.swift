//
//  MainEventsTableViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/21/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

/*
 Handy date to String extension from https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift
 */
public extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

class MainEventsTableViewController: UITableViewController {

    var currentUser: CKRecord?
    var events: [CKRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fetchEvents(){
        let publicDB = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Event", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil){(records: [CKRecord]?, error: Error?) -> Void in
            if let error = error{
                print("An error occurred while loading the events \(error)")
                return
            }
            if let records = records{
                self.events = records
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let records = events{
            return records.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        if let records = events{
            let eventName = records[indexPath.row]["Name"] as! String
            let eventDate = records[indexPath.row]["Date"] as! Date
            if let tmp = cell.textLabel{
                tmp.text = eventName
            }
            if let tmp = cell.detailTextLabel{
                tmp.text = eventDate.toString(dateFormat: "MM-dd")
            }
        }

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let controller = segue.destination as! EventDetailViewController
                controller.event = self.events![indexPath.row]
                controller.currentUser = currentUser
            }
        }
        if segue.identifier == "OptionsSegue" {
            let controller = segue.destination as! OptionsViewController
            controller.events = self.events
            controller.currentUser = currentUser
        }
    }
    
    @IBAction func unwindChangedUser(_ unwindSegue: UIStoryboardSegue){
        if let source = unwindSegue.source as? ChangeAccountViewController{
            self.currentUser = source.editUserData()
            let privateDB = CKContainer.default().privateCloudDatabase
            privateDB.save(self.currentUser!, completionHandler: { (record: CKRecord?, error: Error?) -> Void in
                if let error = error{
                    print("Error when saving updated account info: \(error)")
                    return
                }
            })
        }
    }
    
    @IBAction func unwindNewEvent(_ unwindSegue: UIStoryboardSegue){
        if let source = unwindSegue.source as? CreateEventsViewController{
            print(source.createNewEvent())
            let publicDB = CKContainer.default().publicCloudDatabase
            publicDB.save(source.createNewEvent()!, completionHandler: { (record: CKRecord?, error: Error?) in
                if let error = error{
                    print("Error saving your new event \(error)")
                    return
                }
                DispatchQueue.main.async{
                    self.events!.append(record!)
                    self.tableView.reloadData()
                }
            })
        }
    }
}
