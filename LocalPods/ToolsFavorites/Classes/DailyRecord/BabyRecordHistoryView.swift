//
//  BabyRecordHistoryView.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct BabyRecordHistoryView: View {
    
//    @Binding var selectedTab: Int
    
    @State private var feedingRecords: [Date: [FeedingRecord]] = [:]
    
    var body: some View {
        VStack {
            List {
                ForEach(sortedFeedings, id: \.key) { date, records in
                    Section(header: Text("\(DateUtillity.formattedDateToMMDD(date))    Amount：\(totalAmountToday)").bold().foregroundColor(Color.blue)) {
                        ForEach(records, id: \.time) { record in
                            Text("\(DateUtillity.formattedDateToHHMM(record.time)) - \(record.amount)")
                        }
                    }
                }
            }
            .padding(.bottom, 5)
        }
        .onAppear {
            loadFeedingRecords()
        }
        .commmonNavigationBar(title: "History", displayMode: .inline)
  
    }
    
    private func loadFeedingRecords() {
        if let data = UserDefaults.standard.data(forKey: "feedingRecords") {
            do {
                let decoder = JSONDecoder()
                feedingRecords = try decoder.decode([Date: [FeedingRecord]].self, from: data)
            } catch {
                print("Error decoding feeding records: \(error.localizedDescription)")
            }
        }
    }
    
    private var sortedFeedings: [(key: Date, value: [FeedingRecord])] {
        return feedingRecords.sorted(by: { $0.key > $1.key })
    }
    
    private var totalAmountToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return feedingRecords[today]?.reduce(0, { $0 + $1.amount }) ?? 0
    }
  
}

