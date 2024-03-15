//
//  AmountRecordCacheManager.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-12.
//

import Foundation

class AmountRecordCacheManager: AmountRecordProtocol {
    
    static let shared = AmountRecordCacheManager()
    private static let userDefaultsKey = UserDefaultsConstants.amountRecordDataName
    
    @Published var groupRecords: [Date: [AmountRecord]] = [:]
    
    private init() {
        loadRecords()
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: AmountRecordCacheManager.userDefaultsKey) {
            if let loadedRecords = try? JSONDecoder().decode([Date: [AmountRecord]].self, from: data) {
                groupRecords = loadedRecords
            }
        }
    }
    
    func fetchRecords(forToday onlyToday: Bool, completion: @escaping ([Date: [AmountRecord]]?, Error?) -> Void) {
        if onlyToday {
            let today = Date()
            let todayKey = Calendar.current.startOfDay(for: today)
            if let recordsForToday = groupRecords[todayKey] {
                completion([todayKey: recordsForToday], nil)
            } else {
                completion([:], nil)
            }
        } else {
            completion(groupRecords, nil)
        }
    }

    
    func editRecord(_ record: AmountRecord) {
        guard let dateKey = groupRecords.keys.first(where: { Calendar.current.isDate($0, inSameDayAs: record.time) }) else {
            // If the record's date doesn't match any existing date key, create a new key-value pair
            let newDateKey = Calendar.current.startOfDay(for: record.time)
            groupRecords[newDateKey] = [record]
            saveRecords()
            return
        }
        
        if var dayRecords = groupRecords[dateKey] {
            if let index = dayRecords.firstIndex(where: { Calendar.current.isDate($0.time, equalTo: record.time, toGranularity: .minute) }) {
                // If a record with the same time exists, update it
                dayRecords[index] = record
                groupRecords[dateKey] = dayRecords
                saveRecords()
            } else {
                // If no record with the same time exists, append the new record
                dayRecords.append(record)
                groupRecords[dateKey] = dayRecords
                saveRecords()
            }
        }
    }

    
    func deleRecord(_ record: AmountRecord) {
        guard let dateKey = groupRecords.keys.first(where: { Calendar.current.isDate($0, inSameDayAs: record.time) }) else {
            return
        }
        
        if var dayRecords = groupRecords[dateKey] {
            dayRecords.removeAll(where: { Calendar.current.isDate($0.time, equalTo: record.time, toGranularity: .second) })
            groupRecords[dateKey] = dayRecords
            saveRecords()
        }
    }
    
   
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(groupRecords) {
            UserDefaults.standard.set(encoded, forKey: AmountRecordCacheManager.userDefaultsKey)
        }
    }
}


