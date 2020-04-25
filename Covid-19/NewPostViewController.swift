//
//  NewPostViewController.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postingView: UIView!
    
    var post: DiscussionPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1.0
        postingView.alpha = 1.0
        postingView.layer.cornerRadius = 20
        
        if post == nil {
            post = DiscussionPost()
        }
        
        contentTextView.text = ""
    }
    
    func updateFromUserInterface() {
        post.post = contentTextView.text!
        post.title = titleTextField.text!
    }
    
    func leaveViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        updateFromUserInterface()
        post.saveData { success in
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
