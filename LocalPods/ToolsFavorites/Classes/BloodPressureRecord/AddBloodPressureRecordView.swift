import SwiftUI

struct AddBloodPressureRecordView: View {
    
    @Environment(\.presentationMode) var presentationMode // 获取 presentationMode
       
    
    @Binding var records: [BloodPressureRecord]
    @State private var systolic: String = ""
    @State private var diastolic: String = ""
    @State private var pulse: String = ""
    @State private var isTakingMedicine = false
    @State private var notes: String = ""
    
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
                    
                    Toggle("Medication : ", isOn: $isTakingMedicine)
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
                        .keyboardType(.decimalPad)
                        .padding()

                }
                
                Button(action: addRecord) {
                    Text("Add")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding()
                        .background((systolic.isEmpty || diastolic.isEmpty) ? Color.black.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                    
                }

            }
            .alert(isPresented: $showEmptyAlertMessage) {
                Alert(title: Text("Warning"), message: Text(EmptyAlertMessage), dismissButton: .default(Text("Confirm")))
            }
            .alert(isPresented: $showCompareAlertMessage) {
                Alert(title: Text("Warning"), message: Text(CompareAlertMessage), dismissButton: .default(Text("Confirm")))
            }
            
        }
        .commmonNavigationBar(title: "Add Blood Pressure", displayMode: .inline)
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
    
        records.append(record)
 
        saveRecords()
        
        systolic = ""
        diastolic = ""
        pulse = ""
        isTakingMedicine = false
        notes = ""
        
        presentationMode.wrappedValue.dismiss()
    }

    
    func saveRecords() {
        do {
            let data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: "bloodPressureRecords")
        } catch {
            print("Error saving records: \(error.localizedDescription)")
        }
    }
}
