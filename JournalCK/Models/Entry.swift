//
//  Entry.swift
//  JournalCK
//
//  Created by Travis Chapman on 11/5/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Entry Class

class Entry {
    
    // MARK: - Entry Properties
    
    var title: String
    var body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    var timestampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .long, timeStyle: .none)
    }
    
    // MARK: - Entry Initializers
    
    init(withTitle title: String, body: String) {
        
        self.title = title
        self.body = body
        self.timestamp = Date()
        self.ckRecordID = CKRecord.ID(recordName: UUID().uuidString)
    }
    
    init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[Constants.entryTitleKey] as? String,
            let body = ckRecord[Constants.entryBodyKey] as? String,
            let timestamp = ckRecord[Constants.entryTimestampKey] as? Date
            else { return nil }
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecord.recordID
    }
}

// MARK: - Entry Extension Equatable

extension Entry: Equatable {
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.title == rhs.title && lhs.body == rhs.body && lhs.timestamp == rhs.timestamp && lhs.ckRecordID == rhs.ckRecordID
    }
}

// MARK: - CKRecord Extension

extension CKRecord {
    
    convenience init(entry: Entry) {
        
        // initialize an instance of CKRecord
        self.init(recordType: Constants.entryTypeKey, recordID: entry.ckRecordID)
        
        self.setValue(entry.title, forKey: Constants.entryTitleKey)
        self.setValue(entry.body, forKey: Constants.entryBodyKey)
        self.setValue(entry.timestamp, forKey: Constants.entryTimestampKey)
    }
}
