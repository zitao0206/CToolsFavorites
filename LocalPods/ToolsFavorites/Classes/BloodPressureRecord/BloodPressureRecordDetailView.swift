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
    let isTakingMedicine: String
    let notes: String
    
    public var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedTime = dateFormatter.string(from: time)
        return "\(formattedTime)"
    }

    public static var empty: BloodPressureRecord {
        return BloodPressureRecord(time: Date(), systolic: "", diastolic: "", pulse: "", isTakingMedicine: "NO", notes: "")
    }
}

public struct BloodPressureRecordDetailView: View {
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
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
    
    private var records: [Date: [BloodPressureRecord]] {
       return dataManager.records
    }
    
    @State private var showingSettings = false

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
                                    
                                    HStack {
                                        Text(formattedContentDate(date: record.time))
                                            .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                            .font(.system(size: 12))
                                            .padding(.leading, -10)
                                            .padding(.trailing, 10)
                                        
                                        HStack {
                                            VStack {
                                                Text("Sys")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                                    .padding(.bottom, 5)
                                                Text(record.systolic)
                                                    .font(.system(size: 20))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Int(record.systolic) ?? 0 > 130 ? .red : .green)
                                                
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
                                                    .fontWeight(.bold)
                                                    .foregroundColor((Int(record.diastolic) ?? 0) > 85 ? .red : .green)
                                                
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
                                                    .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.6))
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
                                                Text(record.isTakingMedicine)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.6))
                                                
                                            }
                                        }
                                    }

                 
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.leading, -5)
            .padding(.trailing, -5)

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
            
            NavigationLink(destination: BloodPressureRecordSettingView(), isActive: $showingSettings) {
                EmptyView()
            }
        }
        .navigationBarItems(trailing: Button(action: {
            showingSettings = true
        }) {
            Image(systemName: "gearshape")
                .font(.system(size: 16))
                .foregroundColor(DarkMode.isDarkMode ? .white : .black)
        })
        
        .commmonNavigationBar(title: item.title, displayMode: .inline)
        .onAppear() {
         
        }
    }
    
    
    func formattedTitleDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func formattedContentDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

}

