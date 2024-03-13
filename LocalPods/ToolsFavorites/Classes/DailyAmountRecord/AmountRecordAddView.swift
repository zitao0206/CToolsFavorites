//
//  BabyRecordAddView.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

struct AmountRecordAddView: View {
    
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    @State private var recordElement = AmountRecordElement(time: Date(), amount: 0)
    
    @State private var showAmountAlert = false
    @State private var showContainerAlert = false
    @State private var amountAlertMessage = "Amount must be greater than 0 ！！！"
    
    @FocusState private var isTextFieldFocused: Bool
    
    @ObservedObject var cloudKitManager = AmountRecordCloudKitManager.shared
    @ObservedObject var localCacheManager = AmountRecordCacheManager.shared
    
    private var dataManager : any AmountRecordProtocol {
        let databaseName = UserDefaults.standard.string(forKey: UserDefaultsConstants.amountRecordDatabaseName)
        if let databaseName = databaseName, !databaseName.isEmpty {
            return cloudKitManager
          
        } else {
            return localCacheManager
        }
    }
    
    var body: some View {
    
        VStack {
            
            VStack {
    
                Spacer().frame(height: 20)
                
                HStack {
                    Spacer().frame(width: 7)
                    
                    Text("Current:")
                        .padding(.leading, 9)
                        .padding(.trailing, 10)
                     
                    DatePicker("", selection: $recordElement.time, displayedComponents: .date)
                        .labelsHidden()
                        .padding(.trailing, 20)
                        .onAppear() {
                            recordElement.time = Date()
                        }
                    
                    
                    DatePicker("", selection: $recordElement.time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.trailing, 10)
                        .onAppear() {
                            recordElement.time = Date()
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
                        get: { recordElement.amount > 0 ? "\(recordElement.amount)" : "" },
                            set: {
                                if let value = NumberFormatter().number(from: $0) {
                                    recordElement.amount = value.intValue
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .focused($isTextFieldFocused)
                        .padding(.trailing, 80)

                }
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    isTextFieldFocused = false
                    addFeedingRecord()
                }) {
                    Text("Add")
                        .font(.system(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(.white)
                        .background(recordElement.amount > 0 ? Color.blue : Color.black.opacity(0.3))
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
                        Text("\(DateUtillity.formatDateToHHMM(record.time)) - \(record.amount)")
                            .font(.system(size: 15))

                    }
                    .onDelete(perform: deleteItems)

                }
            }
        } 
        .onAppear {
            loadTodayRecordsFromCloudKit()
            recordElement.time = Date()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            recordElement.time = Date()
        }
       
    }
    
    
    private func addFeedingRecord() {
        
        withAnimation {
            if recordElement.amount <= 0 {
                showAmountAlert = true
                return
            }
            
            let recordItem = AmountRecord(time: recordElement.time, amount: recordElement.amount)
            let date = Calendar.current.startOfDay(for: recordElement.time)
            
            if var records = amountRecords[date] {
                records.insert(recordItem, at: 0)
                amountRecords[date] = records
            } else {
                amountRecords[date] = [recordItem]
            }
            
            dataManager.editRecord(recordItem)
        }

        // reset
        recordElement = AmountRecordElement(time: Date(), amount: 0)
    }
    
    private func deleteItems(offsets: IndexSet) {
        
        withAnimation {
            for index in offsets {
                let todayFeedings = sortedTodayFeedings
                guard index < todayFeedings.count else { continue } // Ensure index is within bounds
                
                let record = todayFeedings[index]
                let date = Calendar.current.startOfDay(for: record.time)
                 
                amountRecords.removeRecord(withId: record.id)

                dataManager.deleRecord(record)
            }
        }
    }
    
    private func loadTodayRecordsFromCloudKit() {
        
        dataManager.fetchRecords(forToday: true) { records, error in
            if let error = error {
                print("Error fetching feeding records from CloudKit: \(error.localizedDescription)")
            } else if let records = records {
                DispatchQueue.main.async {
                    self.amountRecords = records
                    print("YES fetching feeding records from CloudKit: \(self.amountRecords)")
                }
            }
        }

    }
    
    private var sortedTodayFeedings: [AmountRecord] {
        
        let todayRecords = amountRecords
        let today = Calendar.current.startOfDay(for: Date())
        if let recordsForToday = todayRecords[today] {
            return recordsForToday.sorted(by: { $0.time > $1.time })
        } else {
            return []
        }

    }

    
    private var totalAmountToday: Int {
        let todayFeedings = sortedTodayFeedings
        return todayFeedings.reduce(0) { $0 + (Int($1.amount) ?? 0) }
    }


    
    
}
