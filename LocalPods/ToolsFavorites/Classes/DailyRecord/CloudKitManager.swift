//
//  CloudKitManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-05.
//

import CloudKit

struct CloudKitManager {
    
//    static let container = CKContainer(identifier: "iCloud.com.zitao.li0206.CToolsFavorites")
    
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
    
    static func saveRecord(item: AmountRecord) {
        let record = CKRecord(recordType: "AmountRecord")
        record.setValue(item.id, forKey: "id")
        record.setValue(item.time, forKey: "time")
        record.setValue(item.amount, forKey: "amount")
        
        
        publicDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error saving feeding record: \(error.localizedDescription)")
            } else {
                print("Feeding record saved successfully.")
            }
        }
    }

    
    static func deleteRecord(recordID: String) {
        let recordID = CKRecord.ID(recordName: recordID)
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if let error = error {
                print("Error deleting feeding record: \(error.localizedDescription)")
            } else {
                print("Feeding record deleted successfully.")
            }
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

