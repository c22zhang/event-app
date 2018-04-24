//
//  GoingTableViewController.swift
//  EventApp
//  Table view that displays who has RSVPd to an event
//  Created by Christopher Zhang on 4/22/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class GoingTableViewController: UITableViewController {

    var event: CKRecord?
    var peopleGoing: [CKReference]?
    var RSVPs: [CKRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = event{
            if let people = event["RSVP"]{
                peopleGoing = people as? [CKReference]
            }
        }
        fetchRSVPs()
        tableView.reloadData()
    }
    
    func fetchRSVPs(){
        if let going = peopleGoing{
            for record in going{
                RSVPs.append(CKUtils.getFromID(reference: record, database: CKUtils.getPrivateDatabase())!)
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
        return RSVPs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSVPcell", for: indexPath)
        let username = RSVPs[indexPath.row]["Username"] as! String
        if let tmp = cell.textLabel{
            tmp.text = username
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetailSegue"{
            let controller = segue.destination as! UserDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            controller.describingUser = self.RSVPs[indexPath!.row]
        }
    }

}
