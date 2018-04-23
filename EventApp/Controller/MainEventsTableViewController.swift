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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
    }

}
