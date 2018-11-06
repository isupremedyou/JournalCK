//
//  EntryDetailViewController.swift
//  JournalCK
//
//  Created by Travis Chapman on 11/5/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    // MARK: - Constants & Variables
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty
            else { return }
        
        if let entry = entry {
            
            EntryController.shared.update(withEntry: entry, title: title, body: body) { (success) in
                
                if success {
                    
                    DispatchQueue.main.async {
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    
                    print("Error updating")
                    return
                }
            }
        } else {
            
            EntryController.shared.createEntry(withTitle: title, body: body) { (success) in
                
                if success {
                    
                    DispatchQueue.main.async {
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    
                    print("Error saving")
                    return
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func updateViews() {
        
        if let entry = entry {
            
            self.loadViewIfNeeded()
            titleTextField.text = entry.title
            bodyTextView.text = entry.body
            navigationItem.title = entry.timestampAsString
        }
    }
}
