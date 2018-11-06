//
//  EntryListTableViewController.swift
//  JournalCK
//
//  Created by Travis Chapman on 11/5/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: entriesWereSetNotificaiton.name, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @objc func refresh() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EntryController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestampAsString
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let entry = EntryController.shared.entries[indexPath.row]
        
        if editingStyle == .delete {
            
            EntryController.shared.delete(withEntry: entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    return
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toViewEntry" {
            
            guard let destinationVC = segue.destination as? EntryDetailViewController else { return }
            
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            
            destinationVC.entry = EntryController.shared.entries[index]
        }
    }
}
