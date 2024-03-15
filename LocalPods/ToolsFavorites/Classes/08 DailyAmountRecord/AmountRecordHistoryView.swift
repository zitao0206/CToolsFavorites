//
//  AmountRecordHistoryView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct AmountRecordHistoryView: View {
    
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    
    @ObservedObject var cloudKitManager = AmountRecordCloudKitManager.shared
    @ObservedObject var localCacheManager = AmountRecordCacheManager.shared
    
    private var dataManager : any AmountRecordProtocol {
        let databaseName = UserDefaults.standard.string(forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
        if let databaseName = databaseName, !databaseName.isEmpty {
            return cloudKitManager
          
        } else {
            return localCacheManager
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(sortedFeedings, id: \.key) { date, records in
                    if !records.isEmpty {
                        Section(header:
                            Text("\(DateUtillity.formatDateToMMDD(date)) Amount Sum: \(totalAmount(for: date))").bold()
                                .foregroundColor(Color.blue)
                                .textCase(nil)
                        ) {
                            ForEach(records, id: \.time) { record in
                                Text("\(DateUtillity.formatDateToHHMM(record.time)) - \(record.amount)")
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 5)
        }
        .onAppear {
            loadRecords()
        }
        .commmonNavigationBar(title: "History", displayMode: .inline)
  
    }
    
    private func loadRecords() {
        
        dataManager.fetchRecords(forToday: false)  { records, error in
             if let error = error {
                print("Error fetching feeding records from CloudKit: \(error.localizedDescription)")
             } else if let records = records {
                var groupedRecords: [Date: [AmountRecord]] = [:]
                DispatchQueue.main.async {
                  self.amountRecords = records
                }
             }
         }
    }
    
    private var sortedFeedings: [(key: Date, value: [AmountRecord])] {
        return amountRecords.map { (key: $0.key, value: $0.value.sorted(by: { $0.time < $1.time })) }
                           .sorted(by: { $0.key > $1.key })
    }

    
    private func totalAmount(for date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return amountRecords[startOfDay]?.reduce(0, { $0 + (Int($1.amount) ?? 0) }) ?? 0
    }

  
}

