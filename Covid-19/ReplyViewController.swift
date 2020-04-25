//
//  ReplyViewController.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postingView: UIView!
    
    var post: DiscussionPost!
    var reply: Reply!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1.0
        postingView.alpha = 1.0
        postingView.layer.cornerRadius = 20
        
        guard post != nil else {
            print("*** No valid spot")
            return
         }
        
        if reply == nil {
            reply = Reply()
        }
        
        contentTextView.text = ""
        
    }
    
    func updateFromUserInterface() {
        reply.text = contentTextView.text!
    }
    
    func leaveViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        updateFromUserInterface()
        reply.saveData(post: post) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        leaveViewController()
    }
    
}


