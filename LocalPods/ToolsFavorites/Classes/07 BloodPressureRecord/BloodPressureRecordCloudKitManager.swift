//
//  BloodPressureRecordCloudKitManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//


import CloudKit

protocol BloodPressureRecordProtocol : ObservableObject {
    var records: [Date: [BloodPressureRecord]] { get set }
    func loadRecords()
    func addRecord(_ record: BloodPressureRecord)
    func editRecord(_ record: BloodPressureRecord)
    func deleteRecord(_ record: BloodPressureRecord)
}
 
class BloodPressureRecordCloudKitManager : BloodPressureRecordProtocol {
    
    static let shared = BloodPressureRecordCloudKitManager()
    
    @Published var records: [Date: [BloodPressureRecord]] = [:]
    
    static var containerIdentifier: String? {
        get {
            return UserDefaults.standard.string(forKey: "BloodPressureDatabaseName")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BloodPressureDatabaseName")
        }
    }

    static var container: CKContainer {
        guard let identifier = containerIdentifier else {
            return CKContainer.default()
        }
        return CKContainer(identifier: identifier)
    }

    static let publicDatabase = container.publicCloudDatabase
    
    private init() {
        loadRecords()
    }
    
    func addRecord(_ record: BloodPressureRecord) {
        
        let ckRecord = CKRecord(recordType: "BloodPressureRecord")
        
        ckRecord.setValue(record.id, forKey: "id")
        ckRecord.setValue(record.time, forKey: "time")
        ckRecord.setValue(record.systolic, forKey: "systolic")
        ckRecord.setValue(record.diastolic, forKey: "diastolic")
        ckRecord.setValue(record.pulse, forKey: "pulse")
        ckRecord.setValue(record.isTakingMedicine, forKey: "isTakingMedicine")
        ckRecord.setValue(record.notes, forKey: "notes")
        
        BloodPressureRecordCloudKitManager.publicDatabase.save(ckRecord) { (savedRecord, error) in
            if let error = error {
                print("Error saving blood pressure record: \(error.localizedDescription)")
            } else {
                print("Blood pressure record add successfully.")
                DispatchQueue.main.async {
                    let day = record.time.startOfDay()
                    if var dayRecords = self.records[day] {
                        dayRecords.append(record)
                        self.records[day] = dayRecords.sorted(by: { $0.time > $1.time })
                    } else {
                        self.records[day] = [record]
                    }
                }
            }
        }
    }
    
    func editRecord(_ record: BloodPressureRecord) {
        let predicate = NSPredicate(format: "id = %@", record.id)
        let query = CKQuery(recordType: "BloodPressureRecord", predicate: predicate)

        BloodPressureRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error fetching record for editing: \(error.localizedDescription)")
                return
            }

            guard let fetchedRecord = records?.first else {
                print("Record not found for editing.")
                return
            }

            // 更新CKRecord的字段...
            fetchedRecord.setValue(record.id, forKey: "id")
            fetchedRecord.setValue(record.time, forKey: "time")
            fetchedRecord.setValue(record.systolic, forKey: "systolic")
            fetchedRecord.setValue(record.diastolic, forKey: "diastolic")
            fetchedRecord.setValue(record.pulse, forKey: "pulse")
            fetchedRecord.setValue(record.isTakingMedicine, forKey: "isTakingMedicine")
            fetchedRecord.setValue(record.notes, forKey: "notes")
            
            BloodPressureRecordCloudKitManager.publicDatabase.save(fetchedRecord) { (savedRecord, saveError) in
                if let saveError = saveError {
                    print("Error saving edited record: \(saveError.localizedDescription)")
                } else {
                    print("Record edited successfully.")
                    DispatchQueue.main.async {
                        let day = record.time.startOfDay()
                        if var dayRecords = strongSelf.records[day] {
                            if let index = dayRecords.firstIndex(where: { $0.id == record.id }) {
                                dayRecords[index] = record
                                strongSelf.records[day] = dayRecords
                            }
                        }
                    }
                }
            }
        }
    }


    
    func deleteRecord(_ record: BloodPressureRecord) {
        let recordIdPredicate = NSPredicate(format: "id = %@", record.id)
        let query = CKQuery(recordType: "BloodPressureRecord", predicate: recordIdPredicate)
        
        BloodPressureRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error fetching records for deletion: \(error.localizedDescription)")
                return
            }

            guard let recordsToDelete = records, !recordsToDelete.isEmpty else {
                print("No records found for deletion.")
                return
            }

            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordsToDelete.map { $0.recordID })
            BloodPressureRecordCloudKitManager.publicDatabase.add(operation)
            
            operation.modifyRecordsCompletionBlock = { _, deletedRecordIDs, error in
                if let error = error {
                    print("Error deleting records: \(error.localizedDescription)")
                } else {
                    print("Records deleted successfully.")
                    DispatchQueue.main.async {
                        let day = record.time.startOfDay()
                        print("1Records deleted successfully.\(day)")
                        if var dayRecords = strongSelf.records[day] {
                            print("2Records deleted successfully.\(dayRecords.count)")
                            dayRecords.removeAll(where: { $0.id == record.id })
                            print("3Records deleted successfully.\(dayRecords.count)")
                            strongSelf.records[day] = dayRecords.sorted(by: { $0.time > $1.time })
                        }
                    }
                }
            }
        }
    }
    
    func loadRecords() {
        let query = CKQuery(recordType: "BloodPressureRecord", predicate: NSPredicate(value: true))
        BloodPressureRecordCloudKitManager.publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching blood pressure records: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                print("No blood pressure records found.")
                return
            }
            
            var bloodPressureRecords: [BloodPressureRecord] = []
            for record in records {
                if let time = record.object(forKey: "time") as? Date,
                   let systolic = record.object(forKey: "systolic") as? String,
                   let diastolic = record.object(forKey: "diastolic") as? String {
                    
                    let pulse = record.object(forKey: "pulse") as? String ?? ""
                    let isTakingMedicine = record.object(forKey: "isTakingMedicine") as? String ?? "No"
                    let notes = record.object(forKey: "notes") as? String ?? ""

                    let itemRecord = BloodPressureRecord(time: time, systolic: systolic, diastolic: diastolic, pulse: pulse, isTakingMedicine: isTakingMedicine, notes: notes)
                    bloodPressureRecords.append(itemRecord)
                }
            }

            let resultRecords = Dictionary(grouping: bloodPressureRecords, by: { $0.time.startOfDay() }).mapValues { $0.sorted(by: { $0.time > $1.time }) }
            self.records = resultRecords
        }
    }
}






