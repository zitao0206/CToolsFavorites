//
//  AmountRecordModels.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-12.
//

import Foundation

//数据库格式
struct DailyAmountRecord: Identifiable, Codable {
    
    let date: String  //yyyy-MM-dd 
    let records: String // 2024-03-12 22:00:00|200,2024-03-12 20:00:00|100,2024-03-12 13:00:01|200
    
    public var id: String {
        return "\(date)"
    }
}

struct AmountRecord: Identifiable, Codable {
    var time: Date // yyyy-MM-dd HH:MM:ss
    var amount: Int
    public var id: String {
        return "\(DateUtillity.formatDateToString(time))"
    }
}

struct AmountRecordElement: Identifiable {
    var time: Date
    var amount: Int
    public var id: String {
        return "\(DateUtillity.formatDateToString(time))"
    }
}

extension Dictionary where Key == Date, Value == [AmountRecord] {
    mutating func removeRecord(withId id: String) {
        for (date, records) in self {
            self[date] = records.filter { $0.id != id }
        }
    }
}

protocol AmountRecordProtocol : ObservableObject {
    func fetchRecords(forToday onlyToday: Bool, completion: @escaping ([Date: [AmountRecord]]?, Error?) -> Void)
    func editRecord(_ record: AmountRecord)
    func deleRecord(_ record: AmountRecord)
}


