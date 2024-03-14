//
//  BloodPressureRecordSettingView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//

import SwiftUI

struct AmountRecordSettingView: View {
    
    enum StorageOption: String, CaseIterable {
        case local = "Local"
        case remote = "Remote"
    }

    @State private var storageOption: StorageOption = .local
   
    @State private var databaseName: String = UserDefaults.standard.string(forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier) ?? ""


    
    var body: some View {
        
        Form {
            
            Section(header:
                Text("Data Storage")
                    .textCase(nil)
            ) {
                HStack {
                    VStack {
                        Picker("Storage Option", selection: $storageOption) {
                            ForEach(StorageOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if storageOption == .remote {
                            TextField("Database Identifier", text: $databaseName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 13))
                                .onChange(of: databaseName) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
                                }
                            HStack {
                                Spacer()
                                
                                Button {
                                    databaseName = ""
                                    UserDefaults.standard.set("", forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
                                } label: {
                                    Text("Clear")
                                        .font(.system(size: 10))
                                             .padding(5)
                                        .foregroundColor(DarkMode.isDarkMode ? .white : .black)
                                }
                                .buttonStyle(.bordered)
                                
                                Button {
                                    if let clipboardContent = UIPasteboard.general.string {
                                        databaseName = clipboardContent
                                        UserDefaults.standard.set(clipboardContent, forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
                                    }
                                } label: {
                                    Text("Pasted")
                                        .font(.system(size: 10))
                                        .padding(5)
                                        .foregroundColor(DarkMode.isDarkMode ? .white : .black)
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            Text("Note: Using a remote database, data can be shared by multiple people. But before entering this page again, please configure your database with the help of the developer, otherwise you will not be able to use this feature.")
                                .font(.footnote)
                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                .padding()
                        } else {
                            Text("Note: The default option is to store data locally. If local storage is used, it is for personal use only and the data cannot be shared. If you delete the application, the data will be lost.")
                                .font(.footnote)
                                .foregroundColor(DarkMode.isDarkMode ? .white : .black.opacity(0.5))
                                .padding()
                        }
                    }
                }
                
            }
            
            

        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .onAppear {
              
            let savedDatabaseName = UserDefaults.standard.string(forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
            if let savedDatabaseName = savedDatabaseName, !savedDatabaseName.isEmpty {
                // 如果有值，则默认选择Remote选项
                storageOption = .remote
                // 并设置databaseName为已保存的值
                databaseName = savedDatabaseName
            } else {
                // 否则保持默认选项或设置为Local
                storageOption = .local
            }
        }
         
    }
}

 
