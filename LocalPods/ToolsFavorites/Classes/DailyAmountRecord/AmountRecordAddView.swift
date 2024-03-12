//
//  BabyRecordAddView.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct AmountRecord: Identifiable, Codable {
    let time: Date
    let amount: Int
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        return "\(formattedTime)-\(amount)"
    }
}

struct NewAmountRecord {
    var time: Date
    var amount: Int
}

struct AmountRecordAddView: View {
    
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    @State private var newRecord: NewAmountRecord = NewAmountRecord(time: Date(), amount: 0)
    
    @State private var showAmountAlert = false
    @State private var showContainerAlert = false
    @State private var amountAlertMessage = "Amount must be greater than 0 ！！！"
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
    
        VStack {
            
            VStack {
    
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer().frame(width: 7)
                    
                    Text("Current:")
                        .padding(.leading, 9)
                        .padding(.trailing, 10)
                     
                    DatePicker("", selection: $newRecord.time, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.trailing, 20)
                        .onAppear() {
                            newRecord.time = Date()
                        }
                    
                    
                    DatePicker("", selection: $newRecord.time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.trailing, 10)
                        .onAppear() {
                            newRecord.time = Date()
                        }
                   
                    Spacer()
                }
 
                
                Spacer().frame(height: 20)
                
                HStack {
                    
                    Spacer().frame(width: 7)
                    
                    Text("Amount:")
                        .padding(.trailing, 10)
                        .padding(.leading, 5)
                    TextField("amount", text: Binding<String>(
                        get: { newRecord.amount > 0 ? "\(newRecord.amount)" : "" },
                            set: {
                                if let value = NumberFormatter().number(from: $0) {
                                    newRecord.amount = value.intValue
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .focused($isTextFieldFocused)
                        .padding(.trailing, 80)

                }
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    isTextFieldFocused = false
                    addFeedingRecord()
                }) {
                    Text("Add")
                        .font(.system(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(.white)
                        .background(newRecord.amount > 0 ? Color.blue : Color.black.opacity(0.3))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }

            }
    
            .alert(isPresented: $showAmountAlert) {
                Alert(title: Text("Warning"), message: Text(amountAlertMessage), dismissButton: .default(Text("Confirm")))
            }
            
            Spacer().frame(height: 20)
            
            List {
                Section(header: 
                    Text("Today's Amount Sum: \(totalAmountToday)")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .textCase(nil)
                
                ) {
                    ForEach(sortedTodayFeedings) { record in
                        Text("\(DateUtillity.formattedDateToHHMM(record.time)) - \(record.amount)")
                            .font(.system(size: 15))

                    }
                    .onDelete(perform: deleteItems)

                }
            }
        } 
        .onAppear {
            loadRecordsFromCloudKit()
            newRecord.time = Date()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            newRecord.time = Date()
        }
       
    }
    
    
    private func addFeedingRecord() {
        
        withAnimation {
            if newRecord.amount <= 0 {
                showAmountAlert = true
                return
            }
            
            let recordItem = AmountRecord(time: newRecord.time, amount: newRecord.amount)
            let date = Calendar.current.startOfDay(for: newRecord.time)
            
            if var records = amountRecords[date] {
                records.insert(recordItem, at: 0)
                amountRecords[date] = records
            } else {
                amountRecords[date] = [recordItem]
            }
            
            AmountRecordCloudKitManager.saveRecord(item: recordItem)
        }

        // reset
        newRecord = NewAmountRecord(time: Date(), amount: 0)
    }
    
    private func deleteItems(offsets: IndexSet) {
        
        withAnimation {
            for index in offsets {
                let todayFeedings = sortedTodayFeedings
                guard index < todayFeedings.count else { continue } // Ensure index is within bounds
                
                let record = todayFeedings[index]
                let date = Calendar.current.startOfDay(for: record.time)
                
                var records = amountRecords[date] ?? []
                records.remove(at: index)
                
                if records.isEmpty {
                    amountRecords.removeValue(forKey: date)
                } else {
                    amountRecords[date] = records
                }       
                AmountRecordCloudKitManager.deleteRecord(forId: record.id) { error in
                    if let error = error {
                        print("Error deleting records: \(error.localizedDescription)")
                    } else {
                        print("Records deleted successfully.")
                    }
                }
            }
        }
    }
    
    private func loadRecordsFromCloudKit() {
        
        AmountRecordCloudKitManager.fetchRecords { records, error in
            
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
    
    private var sortedTodayFeedings: [AmountRecord] {
        let todayRecords = amountRecords
            .filter { Calendar.current.isDate($0.key, inSameDayAs: Date()) }
            .flatMap { $0.value }
        return todayRecords.sorted(by: { $0.time > $1.time })
    }
    
    private var totalAmountToday: Int {
        let todayFeedings = sortedTodayFeedings
        return todayFeedings.reduce(0) { $0 + $1.amount }
    }


    
    
}
