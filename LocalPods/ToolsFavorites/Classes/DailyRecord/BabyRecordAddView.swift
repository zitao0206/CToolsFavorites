//
//  BabyRecordAddView.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct FeedingRecord: Identifiable, Codable {
    let id = UUID()
    let time: Date
    let amount: Int // 奶量，单位为毫升
}

struct NewFeedingRecord {
    var time: Date
    var amount: Int
}

struct BabyRecordAddView: View {
    
    @Binding var selectedTab: Int
    
    @State private var feedingRecords: [Date: [FeedingRecord]] = [:]
    @State private var newRecord: NewFeedingRecord = NewFeedingRecord(time: Date(), amount: 0)
    
    @State private var showAlert = false
    @State private var alertMessage = "Amount must be greater than 0 ！！！"
    
    var body: some View {
    
        VStack {
            
            Spacer().frame(height: 30)
            
            VStack {
                
                HStack {
                    Text("Time:")
                        .padding(.trailing, 10)
                        .padding(.leading, 20)
                    
                    DatePicker("", selection: $newRecord.time, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.trailing, 20)
                    
                    DatePicker("", selection: $newRecord.time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.trailing, 10)
                   
                    Spacer()
                }
 
                
                Spacer().frame(height: 20)
                
                HStack {
                    Text("Amount:")
                        .padding(.trailing, 10)  
                        .padding(.leading, 20)
                    TextField("amount", text: Binding<String>(
                        get: { "\(newRecord.amount)" },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                newRecord.amount = value.intValue
                            }
                        }
                    ), onCommit: {
                        addFeedingRecord()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.trailing, 20)
                }
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    addFeedingRecord()
                }) {
                    Text("Add Record")
                        .font(.system(size: 16))
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .frame(width: 300, height: 50)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .default(Text("Confirm")))
            }
 
            List {
                Section(header: Text("Today's amount (\(totalAmountToday)ml)").bold().foregroundColor(Color.blue)) {  
                    ForEach(feedingRecords[Calendar.current.startOfDay(for: Date()), default: []], id: \.time) { record in
                        Text("\(DateUtillity.formattedDateToHHMM(record.time)) - \(record.amount)")
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .padding(.bottom, 10)
           
            
        }
        .onAppear {
            loadFeedingRecords()
        }
    }
    
    
    private func addFeedingRecord() {
        withAnimation {
            if newRecord.amount <= 0 {
                showAlert = true
                return
            }
            
            let record = FeedingRecord(time: newRecord.time, amount: newRecord.amount)
            let date = Calendar.current.startOfDay(for: newRecord.time)
            
            if var records = feedingRecords[date] {
                records.insert(record, at: 0) // 将新记录插入到数组的开头位置
                feedingRecords[date] = records
            } else {
                feedingRecords[date] = [record]
            }
        }

        saveFeedingRecords()
        
        // reset
        newRecord = NewFeedingRecord(time: Date(), amount: 0)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
       
            for index in offsets {
             
                let date = Array(feedingRecords.keys)[index]
           
                var records = feedingRecords[date] ?? []
            
                records.remove(at: index)
           
                if records.isEmpty {
                    feedingRecords.removeValue(forKey: date)
                } else {
                
                    feedingRecords[date] = records
                }
            }
    
            saveFeedingRecords()
        }
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
    
    private func saveFeedingRecords() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(feedingRecords)
            UserDefaults.standard.set(data, forKey: "feedingRecords")
        } catch {
            print("Error encoding feeding records: \(error.localizedDescription)")
        }
    }
    
    private var totalAmountToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return feedingRecords[today]?.reduce(0, { $0 + $1.amount }) ?? 0
    }
    
    
}
