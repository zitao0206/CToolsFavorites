//
//  BloodPressureRecordDetailView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-08.
//

import SwiftUI

struct BloodPressureRecord: Identifiable, Codable {
    
    let time: Date // 记录日期
    let systolic: Int // 收缩压
    let diastolic: Int //舒张压
    let pulse: Int //脉搏
    let isTakingMedicine: Bool
    let notes: String
    
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        return "\(formattedTime)-\(systolic)-\(diastolic)"
    }

}

public struct BloodPressureRecordDetailView: View {
    

    @State private var records: [BloodPressureRecord] = [] // 血压记录数组
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }

    public var body: some View {
        VStack {
            List(records) { record in
                VStack(alignment: .leading) {
                    Text("收缩压: \(record.systolic)")
                    Text("舒张压: \(record.diastolic)")
                    Text("日期: \(formattedDate(date: record.time))")
                }
            }
            .padding()
            
            Spacer()
            
            NavigationLink(destination: AddBloodPressureRecordView(records: $records)) {
                Text("添加记录")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 20) // Add horizontal padding
            }
            .padding()
        }
        .commmonNavigationBar(title: item.title, displayMode: .inline)
        .onAppear() {
            loadRecords()
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: "bloodPressureRecords") {
            do {
                records = try JSONDecoder().decode([BloodPressureRecord].self, from: data)
                
            } catch {
                print("Error loading records: \(error.localizedDescription)")
            }
        }
    }
}

