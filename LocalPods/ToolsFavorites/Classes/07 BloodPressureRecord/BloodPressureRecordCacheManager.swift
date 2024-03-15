//
//  BloodPressureRecordCacheManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//

import Foundation

class BloodPressureRecordCacheManager : BloodPressureRecordProtocol {
    
    static let shared = BloodPressureRecordCacheManager()
    
    private static let userDefaultsKey = "UserDefaults.BloodPressureRecord.zitao0206"
    @Published var records: [Date: [BloodPressureRecord]] = [:]
    
    private init() {
        loadRecords()
    }
    
    func loadRecords() {
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
    
    func saveRecordsToUserDefaults() {
        let flatRecords = records.values.flatMap { $0 }
        do {
            let data = try JSONEncoder().encode(flatRecords)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        } catch {
            print("Error encoding blood pressure records: \(error.localizedDescription)")
        }
    }
    
    func editRecord(_ record: BloodPressureRecord) {
        print("editedRecord: \(record)")
        
        let day = record.time.startOfDay()
        
        
        if var dayRecords = records[day] {
            if let index = dayRecords.firstIndex(where: { $0.id == record.id }) {
                dayRecords[index] = record

                dayRecords.sort(by: { $0.time > $1.time })
                records[day] = dayRecords
                saveRecordsToUserDefaults()
            } else {
                addRecord(record)
            }
        } else {
            addRecord(record)
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
    
    func deleteRecord(_ record: BloodPressureRecord) {
        for (day, dayRecords) in records {
            if let index = dayRecords.firstIndex(where: { $0.id == record.id }) {
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
