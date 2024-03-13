//
//  AmountRecordCloudKitManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-05.
//

import CloudKit

class AmountRecordCloudKitManager : AmountRecordProtocol {
   

    static let shared = AmountRecordCloudKitManager()
    
    static var containerIdentifier: String? {
       get {
           return UserDefaults.standard.string(forKey: "UserDefaultsConstants.amountRecordDatabaseName")
       }
       set {
           UserDefaults.standard.set(newValue, forKey: "UserDefaultsConstants.amountRecordDatabaseName")
       }
    }

    static var container: CKContainer {
       guard let identifier = containerIdentifier else {
           return CKContainer.default()
       }
       return CKContainer(identifier: identifier)
    }

    static let publicDatabase = container.publicCloudDatabase
    
    func editRecord(_ record: AmountRecord) {
        let predicate = NSPredicate(format: "date = %@", DateUtillity.formatDateToMMDD(record.time))
        let query = CKQuery(recordType: "DailyAmountRecord", predicate: predicate)

        AmountRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error fetching record for editing: \(error.localizedDescription)")
                return
            }

            var targetRecord : CKRecord
            if let fetchedRecord = records?.first {
                
                // 2024-03-12 22:00:00|200,2024-03-12 20:00:00|100,2024-03-12 13:00:01|200
                let recordsString = fetchedRecord.object(forKey: "records") as? String
                let targetRecordString = ",\(DateUtillity.formatDateToString(record.time))|\(record.amount)"
                
                fetchedRecord.setValue((recordsString ?? "") + targetRecordString, forKey: "records")
                
                targetRecord = fetchedRecord
               
            } else {
                print("Record not found for editing.")
                
                let addRecord = CKRecord(recordType: "DailyAmountRecord")
            
                let targetRecordString = "\(DateUtillity.formatDateToString(record.time))|\(record.amount)"
                let dateString = "\(DateUtillity.formatDateToMMDD(record.time))"
                
                addRecord.setValue(targetRecordString, forKey: "records")
                addRecord.setValue(dateString, forKey: "date")
                
                targetRecord = addRecord
            }
            
            
            AmountRecordCloudKitManager.publicDatabase.save(targetRecord) { (savedRecord, saveError) in
                if let saveError = saveError {
                    print("Error saving edited record: \(saveError.localizedDescription)")
                } else {
                    print("Record edited successfully.")

                }
            }
        }
    }
    
  
    func deleRecord(_ record: AmountRecord) {
        
        let predicate = NSPredicate(format: "date = %@", DateUtillity.formatDateToMMDD(record.time))
        let query = CKQuery(recordType: "DailyAmountRecord", predicate: predicate)
       
        AmountRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error fetching record for editing: \(error.localizedDescription)")
                return
            }

            if let fetchedRecord = records?.first {
                
                // 2024-03-12 22:00:00|200,2024-03-12 20:00:00|100,2024-03-12 13:00:01|200
                let originalRecordsString = fetchedRecord.object(forKey: "records") as? String
                let targetRecordString = "\(DateUtillity.formatDateToString(record.time))|\(record.amount)"
                
                let removedString = AmountRecordCloudKitManager.removeItemFromString(originalRecordsString ?? "", targetRecordString)
                
                fetchedRecord.setValue(removedString, forKey: "records")
                
                AmountRecordCloudKitManager.publicDatabase.save(fetchedRecord) { (savedRecord, saveError) in
                    if let saveError = saveError {
                        print("Error saving edited record: \(saveError.localizedDescription)")
                    } else {
                        print("Record dele successfully.")

                    }
                }
            }
         
        }
    }
    
    static func removeItemFromString(_ string: String, _ targetItem: String) -> String {
        let items = string.components(separatedBy: ",")
        let filteredItems = items.filter { !$0.contains(targetItem) }
        return filteredItems.joined(separator: ",")
    }


    func fetchRecords(forToday onlyToday: Bool, completion: @escaping ([Date: [AmountRecord]]?, Error?) -> Void) {
        let predicate: NSPredicate
        
        if onlyToday {
            predicate = NSPredicate(format: "date = %@", DateUtillity.formatDateToMMDD(Date()))
        } else {
            predicate = NSPredicate(value: true)
        }
        
        let query = CKQuery(recordType: "DailyAmountRecord", predicate: predicate)
        
        AmountRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching feeding records: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let records = records else {
                print("No records found.")
                completion([:], nil)
                return
            }
            
            print("YES fetching feeding records from CloudKit: \(records)")
            
            var groupedRecords: [Date: [AmountRecord]] = [:]
            
            for record in records {
                if let dateString = record.object(forKey: "date") as? String,
                    let recordsString = record.object(forKey: "records") as? String {
                    
                    let records = AmountRecordCloudKitManager.convertStringToAmountRecords(recordsString)
                    
                    if let date = DateUtillity.formatStringToDateMMDD(dateString) {
                        groupedRecords[date] = records
                    }
                }
            }
            
            completion(groupedRecords, nil)
        }
    }

    
    static func convertStringToAmountRecords(_ recordsString: String) -> [AmountRecord] {
        var results = [AmountRecord]()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let components = recordsString.components(separatedBy: ",")
        for component in components {
            let parts = component.components(separatedBy: "|")
            if parts.count == 2 {
                let time = parts[0]
                let amount = parts[1]
                if let date = DateUtillity.formatStringToDate(time) {
                    let item = AmountRecord(time: date, amount: Int(amount) ?? 0)
                    results.append(item)
                }
               
            }
        }

        return results
    }
    

}

