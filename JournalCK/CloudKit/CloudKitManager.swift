//
//  CloudKitManager.swift
//  JournalCK
//
//  Created by Travis Chapman on 11/5/18.
//  Copyright © 2018 Travis Chapman. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    // Create a reference to the CloudKit container/database we will be using
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // Create a fetch records function
    func fetchRecordsWith(type: String, completion: @escaping ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: type, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    // Create a save function that runs the modify function
    func save(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ record: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        modify(records: records, perRecordCompletion: perRecordCompletion, completion: completion)
    }
    
    // Create a generic modify function that uses CKModifyRecordsOperation
    func modify(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ record: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        // Initialize an instance of CKModifyRecordsOperation
        // and pass in the records from the caller
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        // Define the properties of the CK operation
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        // ??
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            completion?(records, error)
        }
        
        privateDB.add(operation)
    }
    
    func delete(records: [CKRecord], completion: ((_ records: [CKRecord]?, _ recordIDs: [CKRecord.ID]?, _ error: Error?) -> Void)?) {
        
        let ckRecordIDs = records.map { (record) -> CKRecord.ID in
            return record.recordID
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: ckRecordIDs)
        
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsCompletionBlock = completion
        
        privateDB.add(operation)
    }
}
