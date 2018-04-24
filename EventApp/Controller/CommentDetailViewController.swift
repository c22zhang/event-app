//
//  CommentDetailViewController.swift
//  EventApp
//  Screen that displays a comment
//  Created by Christopher Zhang on 4/23/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import UIKit
import CloudKit

class CommentDetailViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    
    var comment: CKRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = "Sent By \(comment!["Username"] as! String)"
        timeLabel.text = (comment!["Time"] as! Date).toString(dateFormat: "MM-dd HH:mm")
        detailText.text = comment!["Comment"] as! String
        detailText.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
