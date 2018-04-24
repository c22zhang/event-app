//
//  AddCommentViewController.swift
//  EventApp
//  View where users can add comments
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class AddCommentViewController: UIViewController {
    
    var currentUser: CKRecord?

    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createCommentRecord() -> CKRecord?{
        guard let text = commentText.text else {
            return nil
        }
        
        let newRecord = CKRecord(recordType: "Comment")
        newRecord["Comment"] = text as CKRecordValue
        newRecord["Username"] = currentUser!["Username"]
        newRecord["Time"] = Date() as CKRecordValue
        return newRecord
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if commentText.text! != ""{
            self.message.text = ""
            return true
        }
        else{
            self.message.text = "Missing comment body!"
            return false
        }
    }

}
