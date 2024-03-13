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
    
    @Published var records: [Date: [AmountRecord]] = [:]
    
    private init() {
        loadRecords()
    }
    
    func fetchRecords(forToday onlyToday: Bool, completion: @escaping ([Date: [AmountRecord]]?, Error?) -> Void) {
        if onlyToday {
            let today = Date()
            let todayKey = Calendar.current.startOfDay(for: today)
            if let recordsForToday = records[todayKey] {
                completion([todayKey: recordsForToday], nil)
            } else {
                completion([:], nil)
            }
        } else {
            completion(records, nil)
        }
    }

    
    func editRecord(_ record: AmountRecord) {
        
        guard let dateKey = records.keys.first(where: { Calendar.current.isDate($0, inSameDayAs: record.time) }) else {
            return
        }
        
        if var dayRecords = records[dateKey] {
            if let index = dayRecords.firstIndex(where: { Calendar.current.isDate($0.time, equalTo: record.time, toGranularity: .minute) }) {
                dayRecords[index] = record
                records[dateKey] = dayRecords
                saveRecords()
            }
        }
    }
    
    func deleRecord(_ record: AmountRecord) {
        guard let dateKey = records.keys.first(where: { Calendar.current.isDate($0, inSameDayAs: record.time) }) else {
            return
        }
        
        if var dayRecords = records[dateKey] {
            dayRecords.removeAll(where: { Calendar.current.isDate($0.time, equalTo: record.time, toGranularity: .minute) })
            records[dateKey] = dayRecords
            saveRecords()
        }
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: AmountRecordCacheManager.userDefaultsKey) {
            if let loadedRecords = try? JSONDecoder().decode([Date: [AmountRecord]].self, from: data) {
                records = loadedRecords
            }
        }
    }
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: AmountRecordCacheManager.userDefaultsKey)
        }
    }
}


