//
//  AddBloodPressureRecordView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//

import SwiftUI

struct AddBloodPressureRecordView: View {
    
    @Environment(\.presentationMode) var presentationMode // 获取 presentationMode
        
    var record: BloodPressureRecord
    var action: RecordAction
    
    init(record: BloodPressureRecord, action: RecordAction) {
        self.action = action
        self.record = record
        // 使用 record 的属性值为初始值
        _systolic = State(initialValue: record.systolic)
        _diastolic = State(initialValue: record.diastolic)
        _pulse = State(initialValue: record.pulse)
        _isTakingMedicine = State(initialValue: record.isTakingMedicine)
        _notes = State(initialValue: record.notes)
    }
    
    @State private var systolic: String = ""
    @State private var diastolic: String = ""
    @State private var pulse: String = ""
    @State private var isTakingMedicine: String = "No"
    @State private var notes: String = ""
    
    @ObservedObject var cloudKitManager = BloodPressureRecordCloudKitManager.shared
    @ObservedObject var localCacheManager = BloodPressureRecordCacheManager.shared
    
    private var dataManager : any BloodPressureRecordProtocol {
        let databaseName = UserDefaults.standard.string(forKey: "BloodPressureDatabaseName")
        if let databaseName = databaseName, !databaseName.isEmpty {
            return cloudKitManager
          
        } else {
            return localCacheManager
        }
    }
    
    private var isTakingMedicationBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                self.isTakingMedicine == "Yes"
            },
            set: {
                self.isTakingMedicine = $0 ? "Yes" : "No"
            }
        )
    }

    
    @State private var showEmptyAlertMessage = false
    @State private var EmptyAlertMessage = "Value can not be Empty or Zero ！！！"
    @State private var showCompareAlertMessage = false
    @State private var CompareAlertMessage = "Systolic must be greater than Diastolic！！！"
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 30)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Systolic (mmHg):")
                            .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                            .font(.system(size: 14))
                            .padding(.leading, 15)
                            .padding(.bottom, -15)
                        
                        TextField("High Pressure", text: $systolic)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Diastolic (mmHg):")
                            .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                            .font(.system(size: 14))
                            .padding(.leading, 15)
                            .padding(.bottom, -15)
                        TextField("Low Pressure", text: $diastolic)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Pulse (bmp):")
                            .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                            .font(.system(size: 14))
                            .padding(.leading, 15)
                            .padding(.bottom, -15)
                        TextField("Heartbeat", text: $pulse)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                            .keyboardType(.decimalPad)
                            .padding()
                    }
                    
                    Toggle("Medication : ", isOn: isTakingMedicationBinding)
                        .font(.system(size: 14))
                        .padding()

                }
                
                VStack(alignment: .leading) {
                    Text("Notes")
                        .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                        .font(.system(size: 14))
                        .padding(.leading, 15)
                        .padding(.bottom, -15)
                    TextField("Your condition in detail.", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 16))
                        .padding()
                    
                }
                
                Button(action: action == .edit ? editRecord : addRecord) {
                    Text(action == .edit ? "Edit" : "Add")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding()
                        .background((systolic.isEmpty || diastolic.isEmpty) ? DarkMode.adaptiveAddDisableColor : DarkMode.adaptiveAddEnableColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                
                }
                
                if action == .edit {
                    Button(action: deleteRecord) {
                        Text("Delete")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .padding(.top, 10) // Add top padding
                    }
                }
                

            }
            .alert(isPresented: $showEmptyAlertMessage) {
                Alert(title: Text("Warning"), message: Text(EmptyAlertMessage), dismissButton: .default(Text("Confirm")))
            }
            .alert(isPresented: $showCompareAlertMessage) {
                Alert(title: Text("Warning"), message: Text(CompareAlertMessage), dismissButton: .default(Text("Confirm")))
            }
            
        }
        .commmonNavigationBar(title: self.action == .edit ? "Edit Blood Pressure" : "Add Blood Pressure", displayMode: .inline)
    }
    
    

    func editRecord() {
        print("edit")
        let record = BloodPressureRecord(time: record.time, systolic: systolic, diastolic: diastolic, pulse: pulse, isTakingMedicine: isTakingMedicine, notes: notes)
        dataManager.editRecord(record)

        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteRecord() {
        print("dele")
        dataManager.deleteRecord(record)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addRecord() {
        
        guard let systolicValue = Int(systolic),
              let diastolicValue = Int(diastolic) else {
            showEmptyAlertMessage = true
            return
        }
        
        if systolicValue <= diastolicValue {
            showCompareAlertMessage = true
            return
        }
 
        let record = BloodPressureRecord(time: Date(), systolic: systolic, diastolic: diastolic, pulse: pulse, isTakingMedicine: isTakingMedicine, notes: notes)
    
        dataManager.addRecord(record)
        systolic = ""
        diastolic = ""
        pulse = ""
        isTakingMedicine = "NO"
        notes = ""
        
        presentationMode.wrappedValue.dismiss()
    }

    
    func getYesterdaysDate() -> Date {
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) {
            return yesterday
        } else {
            fatalError("Failed to calculate yesterday's date.")
        }
    }

}
