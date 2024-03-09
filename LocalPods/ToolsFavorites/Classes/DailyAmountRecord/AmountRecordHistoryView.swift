//
//  AmountRecordHistoryView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct BabyRecordHistoryView: View {
    
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    
    var body: some View {
        VStack {
            List {
                ForEach(sortedFeedings, id: \.key) { date, records in
                    Section(header: 
                        Text("\(DateUtillity.formattedDateToMMDD(date)) Amount Sum: \(totalAmount(for:date))").bold()
                            .foregroundColor(Color.blue)
                            .textCase(nil)
                    ) {
                        ForEach(records, id: \.time) { record in
                            Text("\(DateUtillity.formattedDateToHHMM(record.time)) - \(record.amount)")
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
        
        CloudKitManager.fetchRecords { records, error in
             if let error = error {
                 print("Error fetching feeding records from CloudKit: \(error.localizedDescription)")
             } else if let records = records {
                 print("YES fetching feeding records from CloudKit: \(records)")
                 
                 var groupedRecords: [Date: [AmountRecord]] = [:]
                      
                      for record in records {
                          let date = Calendar.current.startOfDay(for: record.time)
                          
                          if var existingRecords = groupedRecords[date] {
                              existingRecords.append(record)
                              groupedRecords[date] = existingRecords
                          } else {
                              groupedRecords[date] = [record]
                          }
                      }
                      
                      // Update amountRecords state variable with grouped records
                      DispatchQueue.main.async {
                          self.amountRecords = groupedRecords
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
        return amountRecords[startOfDay]?.reduce(0, { $0 + $1.amount }) ?? 0
    }

  
}

