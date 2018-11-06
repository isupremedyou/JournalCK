//
//  EntryController.swift
//  JournalCK
//
//  Created by Travis Chapman on 11/5/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    static let shared = EntryController()
    
    let cloudKitManager = CloudKitManager()
    
    var entries = [Entry]()
    
    // MARK: - CRUD Functions
    
    func createEntry(withTitle title: String, body: String, completion: @escaping (Bool) -> Void) {
        
        let entry = Entry(withTitle: title, body: body)
        
        let entryAsRecord = CKRecord(entry: entry)
        
        cloudKitManager.save(records: [entryAsRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving records to CloudKit: \n\(#function)\n\(error)\n\(error.localizedDescription)")
                completion(false)
                return
            } else {
                self.entries.append(entry)
                completion(true)
            }
        }
    }
    
    func update(withEntry entry: Entry, title: String, body: String, completion: @escaping (Bool) -> Void) {
        
        // Get the index of the old entry
        guard let index = entries.firstIndex(of: entry) else { return }
        
        // Update the instance of Entry with the new title and body, then attempt to update the CloudKit record
        entry.title = title
        entry.body = body
        let updatedEntryAsRecord = CKRecord(entry: entry)
        
        cloudKitManager.modify(records: [updatedEntryAsRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error updating records in CloudKit: \n\(#function)\n\(error)\n\(error.localizedDescription)")
                completion(false)
                return
            } else {
                self.entries[index].title = title
                self.entries[index].body = body
                completion(true)
            }
        }
    }
    
    func delete(withEntry entry: Entry, completion: @escaping (Bool) -> Void) {
        
        // Get the index of the entry
        guard let index = entries.firstIndex(of: entry) else { return }
        
        let entryAsRecord = CKRecord(entry: entry)
        
        cloudKitManager.delete(records: [entryAsRecord]) { (_, _, error) in
            if let error = error {
                print("Error deleting the record: \n\(#function)\n\(error)\n\(error.localizedDescription)")
                completion(false)
                return
            } else {
                self.entries.remove(at: index)
                completion(true)
            }
        }
    }
    
    func fetchEntriesFromCK(completion: @escaping (Bool) -> Void) {
        
        cloudKitManager.fetchRecordsWith(type: Constants.entryTypeKey) { (records, error) in
            if let error = error {
                print("Error fetching records from CloudKit: \n\(#function)\n\(error)\n\(error.localizedDescription)")
                completion(false)
                return
            } else {
                guard let records = records else { return }
                
                for record in records {
                    guard let entry = Entry(ckRecord: record) else { return }
                    self.entries.append(entry)
                }
                completion(true)
            }
        }
    }
}
