//
//  AmountRecordCloudKitManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-05.
//

import CloudKit

struct AmountRecordCloudKitManager {
    
    static var containerIdentifier: String? {
       get {
           return UserDefaults.standard.string(forKey: "containerIdentifier")
       }
       set {
           UserDefaults.standard.set(newValue, forKey: "containerIdentifier")
       }
    }

    static var container: CKContainer {
       guard let identifier = containerIdentifier else {
           return CKContainer.default()
       }
       return CKContainer(identifier: identifier)
    }

    static let publicDatabase = container.publicCloudDatabase
    
    
    
    static func updateRecord(item: AmountRecord) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: item.time)
        let predicate = NSPredicate(format: "date = %@", currentDate)
        let query = CKQuery(recordType: "AmountRecordList", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) in
            if let error = error {
                print("888: Error fetching feeding records: \(error.localizedDescription)")
                return
            }
            
            guard let fetchedRecord = records?.first else {
                print("Record not found for editing.")
                return
            }
            
            print("888:---->AmountRecordList: \(fetchedRecord)")
            var items: [CKRecord.Reference]? = fetchedRecord.object(forKey: "records") as? [CKRecord.Reference]
            
          
            
            let amountRecord = CKRecord(recordType: "AmountRecord")
            amountRecord.setValue(item.time, forKey: "time")
            amountRecord.setValue(item.amount, forKey: "amount")
            
            publicDatabase.save(amountRecord) { (record, error) in
                if let error = error {
                    print("Error saving feeding record: \(error.localizedDescription)")
                } else {
                    
                    let reference = CKRecord.Reference(record: amountRecord, action: .none)
                    if items != nil {
                        items?.append(reference)
                    } else {
                        items = [reference]
                    }
                    
                    if let _items = items {
                        fetchedRecord.setObject(_items as __CKRecordObjCValue, forKey: "records")
                    }
                    publicDatabase.save(fetchedRecord) { (record, error) in
                        if let error = error {
                            print("999: Error saving AmountRecordList: \(error.localizedDescription)")
                            return
                        }
                        print("999: AmountRecordList saved successfully.")
                    }
                }
            }
            
      
        }

        
    }

    static func saveRecord(item: AmountRecord) {
        
        let record = CKRecord(recordType: "AmountRecord")
        record.setValue(item.id, forKey: "id")
        record.setValue(item.time, forKey: "time")
        record.setValue(item.amount, forKey: "amount")
        
        
        publicDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error saving feeding record: \(error.localizedDescription)")
            } else {
                print("Feeding record saved successfully.\(item.id)")
            }
        }
    }
  
    static func deleteRecord(forId recordId: String, completion: @escaping (Error?) -> Void) {
        // Create a predicate to filter records for the specified amount
        let recordIdPredicate = NSPredicate(format: "id = %@", recordId)
        
        let query = CKQuery(recordType: "AmountRecord", predicate: recordIdPredicate)
        
        // Perform the query to fetch records for the specified amount
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records, error == nil else {
                print("Error fetching records for deletion: \(error?.localizedDescription ?? "Unknown error")")
                completion(error)
                return
            }
            
            // Delete each fetched record
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records.map { $0.recordID })
            operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, operationError in
                if let operationError = operationError {
                    print("Error deleting records: \(operationError.localizedDescription)")
                    completion(operationError)
                } else {
                    print("Records deleted successfully.")
                    completion(nil)
                }
            }
            publicDatabase.add(operation)
        }
    }


    
    static func fetchRecords(completion: @escaping ([AmountRecord]?, Error?) -> Void) {
        let query = CKQuery(recordType: "AmountRecord", predicate: NSPredicate(value: true))
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
           
            if let error = error {
                print("Error fetching feeding records: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let records = records else {
                print("No records found.")
                completion([], nil)
                return
            }
            
            
            
            var amountRecords: [AmountRecord] = []
            for record in records {
                if let time = record.object(forKey: "time") as? Date,
                   let amount = record.object(forKey: "amount") as? Int {
                    let itemRecord = AmountRecord(time: time, amount: amount)
                    amountRecords.append(itemRecord)
                }
            }
            
            completion(amountRecords, nil)
        }
    }
}

