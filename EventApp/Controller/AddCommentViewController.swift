//
//  AddCommentViewController.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class AddCommentViewController: UIViewController {
    
    var currentUser: CKRecord?

    @IBOutlet weak var commentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
