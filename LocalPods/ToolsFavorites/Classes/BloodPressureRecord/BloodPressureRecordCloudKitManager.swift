//
//  BloodPressureRecordCloudKitManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//


import CloudKit

struct BloodPressureRecordCloudKitManager {
    
    static var containerIdentifier: String? {
        get {
            return "iCloud.BloodPressureRecord.zitao0206" //UserDefaults.standard.string(forKey: "containerIdentifier")
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
    
    static func saveRecord(record: BloodPressureRecord) {
        let recordID = CKRecord.ID(recordName: record.id)
        let ckRecord = CKRecord(recordType: "BloodPressureRecord", recordID: recordID)
        ckRecord.setValue(record.time, forKey: "time")
        ckRecord.setValue(record.systolic, forKey: "systolic")
        ckRecord.setValue(record.diastolic, forKey: "diastolic")
        ckRecord.setValue(record.pulse, forKey: "pulse")
        ckRecord.setValue(record.isTakingMedicine, forKey: "isTakingMedicine")
        ckRecord.setValue(record.notes, forKey: "notes")
        
        publicDatabase.save(ckRecord) { (savedRecord, error) in
            if let error = error {
                print("Error saving blood pressure record: \(error.localizedDescription)")
            } else {
                print("Blood pressure record saved successfully.")
            }
        }
    }
    
    static func deleteRecord(forId recordId: String, completion: @escaping (Error?) -> Void) {
        let recordID = CKRecord.ID(recordName: recordId)
        publicDatabase.delete(withRecordID: recordID) { (deletedRecordId, error) in
            if let error = error {
                print("Error deleting blood pressure record: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Blood pressure record deleted successfully.")
                completion(nil)
            }
        }
    }
    
    static func fetchRecords(completion: @escaping ([BloodPressureRecord]?, Error?) -> Void) {
        let query = CKQuery(recordType: "BloodPressureRecord", predicate: NSPredicate(value: true))
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching blood pressure records: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let records = records else {
                print("No blood pressure records found.")
                completion([], nil)
                return
            }
            
            var bloodPressureRecords: [BloodPressureRecord] = []
            for record in records {
                if let time = record.object(forKey: "time") as? Date,
                   let systolic = record.object(forKey: "systolic") as? String,
                   let diastolic = record.object(forKey: "diastolic") as? String,
                   let pulse = record.object(forKey: "pulse") as? String,
                   let isTakingMedicine = record.object(forKey: "isTakingMedicine") as? Bool,
                   let notes = record.object(forKey: "notes") as? String {
                    let itemRecord = BloodPressureRecord(time: time, systolic: systolic, diastolic: diastolic, pulse: pulse, isTakingMedicine: isTakingMedicine, notes: notes)
                    bloodPressureRecords.append(itemRecord)
                }
            }
            
            completion(bloodPressureRecords, nil)
        }
    }
}


import Foundation

class BloodPressureRecordCacheManager {
    
    static let shared = BloodPressureRecordCacheManager()
    
    private static let userDefaultsKey = "UserDefaults.BloodPressureRecord.zitao0206"
    var records: [Date: [BloodPressureRecord]] = [:]
    
    private init() {
        loadRecordsFromUserDefaults()
    }
    
    private func loadRecordsFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) else {
            return
        }
        do {
            let decodedRecords = try JSONDecoder().decode([BloodPressureRecord].self, from: data)
            // Group by day and sort each group
            self.records = Dictionary(grouping: decodedRecords, by: { $0.time.startOfDay() }).mapValues { $0.sorted(by: { $0.time > $1.time }) }
        } catch {
            print("Error decoding blood pressure records: \(error.localizedDescription)")
        }
    }
    
    private func saveRecordsToUserDefaults() {
        let flatRecords = records.values.flatMap { $0 }
        do {
            let data = try JSONEncoder().encode(flatRecords)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        } catch {
            print("Error encoding blood pressure records: \(error.localizedDescription)")
        }
    }
    
    func editRecord(_ editedRecord: BloodPressureRecord) {
        print("editedRecord: \(editedRecord)")
        
        let day = editedRecord.time.startOfDay()
        
        
        if var dayRecords = records[day] {
            if let index = dayRecords.firstIndex(where: { $0.id == editedRecord.id }) {
                dayRecords[index] = editedRecord

                dayRecords.sort(by: { $0.time > $1.time })
                records[day] = dayRecords
                saveRecordsToUserDefaults()
            } else {
                addRecord(editedRecord)
            }
        } else {
            addRecord(editedRecord)
        }
    }

    
    func addRecord(_ record: BloodPressureRecord) {
        let day = record.time.startOfDay()
        var dayRecords = records[day] ?? []
        
        // Find the correct insertion point to keep the array sorted
        let index = dayRecords.firstIndex { $0.time < record.time } ?? dayRecords.endIndex
        dayRecords.insert(record, at: index)
        
        records[day] = dayRecords
        saveRecordsToUserDefaults()
    }
    
    func deleteRecord(_ recordToDelete: BloodPressureRecord) {
        for (day, dayRecords) in records {
            if let index = dayRecords.firstIndex(where: { $0.id == recordToDelete.id }) {
                var updatedRecords = dayRecords
                updatedRecords.remove(at: index)
                records[day] = updatedRecords
                break
            }
        }
        saveRecordsToUserDefaults()
    }
    
    func clearRecords() {
        records = [:]
        UserDefaults.standard.removeObject(forKey: Self.userDefaultsKey)
    }
    
    func recordsForDate(_ date: Date) -> [BloodPressureRecord] {
        let day = date.startOfDay()
        return records[day] ?? []
    }
}

extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}



