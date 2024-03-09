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
    
    @State private var selectedAge: Int = 30
    @State private var selectedGender: Gender = .male
      
    private let ageRange: [Int] = Array(18...100)
    private let genderOptions: [Gender] = [.male, .female, .other]

    @State private var showingNormalBloodImage = false
    @State private var showingHighBloodImage = false

    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
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
            
            Section(header: Text("Blood Pressure Information")) {
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

        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .onAppear {
            selectedAge = UserDefaults.standard.integer(forKey: UserDefaults.selectedAgeKey) != 0 ? UserDefaults.standard.integer(forKey: UserDefaults.selectedAgeKey) : 30
            selectedGender = Gender(rawValue: UserDefaults.standard.string(forKey: UserDefaults.selectedGenderKey) ?? "Male") ?? .male
        }
    }
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(selectedAge, forKey: UserDefaults.selectedAgeKey)
        UserDefaults.standard.set(selectedGender.rawValue, forKey: UserDefaults.selectedGenderKey)
    }
}

 
