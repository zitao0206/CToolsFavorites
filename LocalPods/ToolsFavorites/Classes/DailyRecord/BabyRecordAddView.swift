//
//  BabyRecordAddView.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct AmountRecord: Identifiable, Codable {
    let id = UUID().uuidString
    let time: Date
    let amount: Int
}

struct NewAmountRecord {
    var time: Date
    var amount: Int
}

struct BabyRecordAddView: View {
    
 
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    @State private var newRecord: NewAmountRecord = NewAmountRecord(time: Date(), amount: 0)
    
    @State private var showAlert = false
    @State private var alertMessage = "Amount must be greater than 0 ！！！"
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
    
        VStack {
            
            Spacer().frame(height: 10)
            
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
                        .padding(.leading, 5)
                    TextField("amount", text: Binding<String>(
                            get: { "\(newRecord.amount)" },
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
                HStack {
                    Button(action: {
                        isTextFieldFocused = false
                        addFeedingRecord()
                    }) {
                        Text("Add Record")
                            .font(.system(size: 15))
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .frame(width: 160, height: 20)
                    Spacer().frame(width: 20)
                    NavigationLink(destination: BabyRecordHistoryView()) {
                        Text("History")
                            .foregroundColor(DarkMode.isDarkMode ? .white : .black)
                            .padding()
                            .background(DarkMode.isDarkMode ? .white.opacity(0.3) : .black.opacity(0.3))
                            .frame(width: 70, height: 40)
                            .cornerRadius(8)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .default(Text("Confirm")))
            }
            
            Spacer().frame(height: 30)
            
            List {
                Section(header: Text("Today's amount (\(totalAmountToday)ml)").bold().foregroundColor(Color.blue)) {  
                    ForEach(amountRecords[Calendar.current.startOfDay(for: Date()), default: []], id: \.time) { record in
                        Text("\(DateUtillity.formattedDateToHHMM(record.time)) - \(record.amount)")
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        } 
        .onAppear {
            loadRecordsFromCloudKit()
        }
       
    }
    
    
    private func addFeedingRecord() {
        
        withAnimation {
            if newRecord.amount <= 0 {
                showAlert = true
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
            
            CloudKitManager.saveRecord(item: recordItem)
        }

        // reset
        newRecord = NewAmountRecord(time: Date(), amount: 0)
    }
    
    private func deleteItems(offsets: IndexSet) {
        
        withAnimation {
       
            for index in offsets {
             
                let date = Array(amountRecords.keys)[index]
           
                var records = amountRecords[date] ?? []
            
               let item = records.remove(at: index)
           
                if records.isEmpty {
                    amountRecords.removeValue(forKey: date)
                } else {
                    amountRecords[date] = records
                }
                
                CloudKitManager.deleteRecord(recordID: item.id)
            }
    
        }
    }
    
    private func loadRecordsFromCloudKit() {
        
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
    
    private var totalAmountToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return amountRecords[today]?.reduce(0, { $0 + $1.amount }) ?? 0
    }
    
    
}
