//
//  BloodPressureRecordDetailView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//


import SwiftUI

enum RecordAction {
    case add
    case edit
}

public struct BloodPressureRecord: Identifiable, Codable {
    
    let time: Date
    let systolic: String
    let diastolic: String
    let pulse: String  
    let isTakingMedicine: Bool
    let notes: String
    
    public var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        return "\(formattedTime)"
    }

    public static var empty: BloodPressureRecord {
        return BloodPressureRecord(time: Date(), systolic: "", diastolic: "", pulse: "", isTakingMedicine: false, notes: "")
    }
}

public struct BloodPressureRecordDetailView: View {
    

    @State private var records: [Date: [BloodPressureRecord]] = [:]
    
//    @State private var records: [BloodPressureRecord] = []
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }

    public var body: some View {
        ZStack {
            List {
                ForEach(records.sorted(by: { $0.key > $1.key }), id: \.key) { date, recordsInSameDate in
                    Section(header: 
                        Text(formattedTitleDate(date: date)).font(.headline)
                            .padding(.leading, -15)
                    ) {
                        ForEach(recordsInSameDate) { record in
                            NavigationLink(destination: AddBloodPressureRecordView(record: record, action: .edit)) {
                            
                                VStack(alignment: .leading) {
                                    
                                    Text(formattedContentDate(date: record.time))
                                        .font(.system(size: 14))
                                        .padding(.bottom, 5)
                                    
                                    HStack {
                                        VStack {
                                            Text("Sys")
                                                .font(.system(size: 15))
                                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                                .padding(.bottom, 5)
                                            Text(record.systolic)
                                                .font(.system(size: 20))
                                            
                                        }
                                        Spacer()
                                        VStack {
                                            Text(" ")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 5)
                                            Text("/")
                                                .font(.system(size: 20))
                                                .foregroundColor(DarkMode.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3))
                                        }
                                        Spacer()
                                        VStack {
                                            Text("Dia")
                                                .font(.system(size: 15))
                                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                                .padding(.bottom, 5)
                                            Text(record.diastolic)
                                                .font(.system(size: 20))
                                            
                                        }
                                        Spacer()
                                        VStack {
                                            Text(" ")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 5)
                                            Text("/")
                                                .font(.system(size: 20))
                                                .foregroundColor(DarkMode.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3))
                                        }
                                        Spacer()
                                        VStack {
                                            Text("Pulse")
                                                .font(.system(size: 15))
                                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                                .padding(.bottom, 5)
                                            Text(record.pulse.isEmpty ? "-" : record.pulse)
                                                .font(.system(size: 20))
                                        }
                                        Spacer()
                                        VStack {
                                            Text(" ")
                                                .font(.system(size: 15))
                                                .padding(.bottom, 5)
                                            Text("/")
                                                .font(.system(size: 20))
                                                .foregroundColor(DarkMode.isDarkMode ? .white.opacity(0.5) : .black.opacity(0.3))
                                        }
                                        Spacer()
                                        VStack {
                                            Text("Med")
                                                .font(.system(size: 15))
                                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                                .padding(.bottom, 5)
                                            Text(record.isTakingMedicine ? "Yes" : "No")
                                                .font(.system(size: 20))
                                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.8))
                                            
                                        }
                                    }
                 
                                }
                            }
                        }
                    }
                }
            }
            
            .padding()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: AddBloodPressureRecordView(record: BloodPressureRecord.empty, action: .add)) {
                        Image(systemName: "plus")
                           .foregroundColor(.white)
                           .font(.headline)
                           .padding(20)
                           .background(Color.blue)
                           .clipShape(Circle())
                           .padding(.trailing, 20)
                           .padding(.bottom, 20)
                    }
                    .padding()
                }
            }
        }
        .commmonNavigationBar(title: item.title, displayMode: .inline)
        .onAppear() {
            loadRecords()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        
    }
    
    func formattedTitleDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEEE"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    func formattedContentDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    func loadRecords() {
        records = BloodPressureRecordCacheManager.shared.records
    }
 

}

