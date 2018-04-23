//
//  CommentsTableViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class CommentsTableViewController: UITableViewController {

    var event: CKRecord?
    var comments: [CKRecord] = []
    var currentUser: CKRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchComments(){
        self.comments = []
        let references = event!["Comments"] as! [CKReference]
        for reference in references{
            self.comments.append(EventDetailViewController.getFromID(reference: reference, database: CKContainer.default().publicCloudDatabase)!)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)

        let comment = comments[indexPath.row]["Comment"] as! String
        let date = comments[indexPath.row]["Time"] as! Date
        let dateString = date.toString(dateFormat: "MM-dd HH:mm")
        if let tmp = cell.textLabel{
            tmp.text = comment
        }
        if let tmp = cell.detailTextLabel{
            tmp.text = dateString
        }
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            if segue.identifier == "CommentDetailSegue"{
                let controller = segue.destination as! CommentDetailViewController
                controller.comment = comments[indexPath.row]
            }
        }
        if segue.identifier == "AddCommentSegue" {
            let controller = segue.destination as! AddCommentViewController
            controller.currentUser = self.currentUser
            print("from comment table view \(self.currentUser)")
        }
    }
    
     @IBAction func unwindNewComment(_ unwindSegue: UIStoryboardSegue){
        if let newCommentController = unwindSegue.source as? AddCommentViewController{
            let newRecord = newCommentController.createCommentRecord()
            let publicDB = CKContainer.default().publicCloudDatabase
            publicDB.save(newRecord!){ (ckRecord: CKRecord?, error: Error?) -> Void in
                if let error = error{
                    print("An error occurred while saving your comment \(error)")
                    return
                }
                DispatchQueue.main.async{
                    self.addCommentsToEvent(comment: ckRecord!)
                    self.fetchComments()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func addCommentsToEvent(comment: CKRecord?) {
        var references = event!["Comments"] as! [CKReference]
        let newReference = CKReference(recordID: comment!.recordID, action: .none)
        references.append(newReference)
        event!["Comments"] = references as CKRecordValue
        
        let publicDB = CKContainer.default().publicCloudDatabase
        let updateCommentGroup = DispatchGroup()
        updateCommentGroup.enter()
        DispatchQueue.global().async(){
            publicDB.save(self.event!) {(ckRecord: CKRecord?, error: Error?) -> Void in
                if let error = error {
                    print("An error occurred while updating the event \(error)")
                    updateCommentGroup.leave()
                    return
                }
                else{
                    self.event = ckRecord
                    updateCommentGroup.leave()
                    return
                }
            }
        }
        updateCommentGroup.wait()
    }

}
