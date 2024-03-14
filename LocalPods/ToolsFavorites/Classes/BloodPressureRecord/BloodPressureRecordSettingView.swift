//
//  BloodPressureRecordSettingView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-09.
//

import SwiftUI

extension UserDefaults {
    static let selectedAgeKey = "selectedAge"
    static let selectedGenderKey = "selectedGender"
}

struct BloodPressureRecordSettingView: View {
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    enum StorageOption: String, CaseIterable {
        case local = "Local"
        case remote = "Remote"
    }

    
    @State private var selectedAge: Int = 30
    @State private var selectedGender: Gender = .male
      
    private let ageRange: [Int] = Array(18...100)
    private let genderOptions: [Gender] = [.male, .female, .other]

    @State private var showingNormalBloodImage = false
    @State private var showingHighBloodImage = false

    @State private var storageOption: StorageOption = .local
   
    @State private var databaseName: String = UserDefaults.standard.string(forKey: "BloodPressureDatabaseName") ?? ""


    
    var body: some View {
        Form {
            Section(header: 
                Text("Personal Information")
                    .textCase(nil)
                ) {
                Picker("Age", selection: $selectedAge) {
                    ForEach(ageRange, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                .onChange(of: selectedAge) { _ in
                    print("年龄按钮被点击")
                    saveSettings()
                }
                
                Picker("Gender", selection: $selectedGender) {
                    ForEach(genderOptions, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .onChange(of: selectedGender) { _ in
                    saveSettings()
                }
                
            }
            
            Section(header: 
                Text("Blood Pressure Information")
                    .textCase(nil)
            ) {
                Button(action: {
                    self.showingNormalBloodImage = true
                }) {
                    HStack {
                        Text("Normal Blood Pressure Standard")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .background(Color.clear)
                
                Button(action: {
                    self.showingHighBloodImage = true
                }) {
                    HStack {
                        Text("High Blood Pressure")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .background(Color.clear)

            }
            .sheet(isPresented: $showingNormalBloodImage) {
                if let image = ImageUtility.loadImage(named: "normalbloodpressurestandard", withExtension: "jpg") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                ImageUtility.saveImageToAlbum(image)
                            }) {
                                Text("Save to Photos")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                } else {
                    Text("Failed to load image")
                }
            }
            .sheet(isPresented: $showingHighBloodImage) {
                if let image = ImageUtility.loadImage(named: "highbloodpressure", withExtension: "jpg") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                ImageUtility.saveImageToAlbum(image)
                            }) {
                                Text("Save to Photos")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                } else {
                    Text("Failed to load image")
                }
            }
            
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
                            TextField("Database Name", text: $databaseName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 13))
                                .onChange(of: databaseName) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "BloodPressureDatabaseName")
                                }
                            HStack {
                                Spacer()
                                
                                Button {
                                    databaseName = ""
                                    UserDefaults.standard.set("", forKey: "BloodPressureDatabaseName")
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
                                        UserDefaults.standard.set(clipboardContent, forKey: "BloodPressureDatabaseName")
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
            selectedAge = UserDefaults.standard.integer(forKey: UserDefaults.selectedAgeKey) != 0 ? UserDefaults.standard.integer(forKey: UserDefaults.selectedAgeKey) : 30
            selectedGender = Gender(rawValue: UserDefaults.standard.string(forKey: UserDefaults.selectedGenderKey) ?? "Male") ?? .male
              
            let savedDatabaseName = UserDefaults.standard.string(forKey: "BloodPressureDatabaseName")
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
    
    
    
    private func saveSettings() {
        UserDefaults.standard.set(selectedAge, forKey: UserDefaults.selectedAgeKey)
        UserDefaults.standard.set(selectedGender.rawValue, forKey: UserDefaults.selectedGenderKey)
    }
}

 
