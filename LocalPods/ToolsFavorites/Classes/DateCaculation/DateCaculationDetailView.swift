//
//  DateCalculationDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/24.
//

import SwiftUI


public struct DateCalculationDetailView: View {
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @State private var selectedOption = 0
    
    let options = ["Date Difference", "Date Calculate"]
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
            Picker("Select Option", selection: $selectedOption) {
                ForEach(0 ..< options.count) {
                    Text(self.options[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedOption == 0 {
                DateDifferenceDetailView()
            } else {
                DateAddCalculationDetailView()
            }
        }
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {
//            NotificationCenter.default.post(name: .moveItemToFirstNotification, object: self.index)
        }
    }
}



public struct DateDifferenceDetailView: View {
    @State private var beforeYear = ""
    @State private var beforeMonth = ""
    @State private var beforeDay = ""

    @State private var afterYear = ""
    @State private var afterMonth = ""
    @State private var afterDay = ""

    @State private var differenceResult = ""

    public var body: some View {
        VStack {

            VStack(spacing: 10) {
                HStack {
                    
                    Text("Y")
                    TextField("Year", text: $beforeYear)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                
                    Text("M")
                    TextField("Month", text: $beforeMonth)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                    
                    Text("D")
                    TextField("Day", text: $beforeDay)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                    
                    Button("Today", action: {
                        let today = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day], from: today)
                        beforeYear = "\(components.year ?? 0)"
                        beforeMonth = "\(components.month ?? 0)"
                        beforeDay = "\(components.day ?? 0)"
                    })
                }
                
                Spacer().frame(height: 20)
                
                Text("To")
                    .font(.system(size: 18))
                
                Spacer().frame(height: 20)
                
                HStack {
                    
                    Text("Y")
                    TextField("Year", text: $afterYear)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    
                    Text("M")
                    TextField("Month", text: $afterMonth)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                    
                    Text("D")
                    TextField("Day", text: $afterDay)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                    
                    Button("Today", action: {
                        let today = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day], from: today)
                        afterYear = "\(components.year ?? 0)"
                        afterMonth = "\(components.month ?? 0)"
                        afterDay = "\(components.day ?? 0)"
                    })
                }
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    calculateDifference()
                }) {
                    Text("Calculate")
                        .font(.system(size: 16))
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Spacer().frame(height: 30)

                Text("Difference Result:")
                    .font(.system(size: 18))
                    .foregroundColor(.black.opacity(0.3))
                    .multilineTextAlignment(.center) // 将文本居中显示
                    .padding(.top)

                Text("\(differenceResult)")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center) // 将文本居中显示

            }
            .padding()
            Spacer()
        }
     
    }

    private func calculateDifference() {
        // Convert string inputs to integers
        guard let beforeYearInt = Int(beforeYear),
              let beforeMonthInt = Int(beforeMonth),
              let beforeDayInt = Int(beforeDay),
              let afterYearInt = Int(afterYear),
              let afterMonthInt = Int(afterMonth),
              let afterDayInt = Int(afterDay) else {
            differenceResult = "Invalid input"
            return
        }

        // Create DateComponents for both dates
        var beforeComponents = DateComponents()
        beforeComponents.year = beforeYearInt
        beforeComponents.month = beforeMonthInt
        beforeComponents.day = beforeDayInt

        var afterComponents = DateComponents()
        afterComponents.year = afterYearInt
        afterComponents.month = afterMonthInt
        afterComponents.day = afterDayInt

        // Create Calendar and get the difference
        let calendar = Calendar.current
        guard let beforeDate = calendar.date(from: beforeComponents),
              let afterDate = calendar.date(from: afterComponents) else {
            differenceResult = "Invalid date"
            return
        }

        let difference = calendar.dateComponents([.day], from: beforeDate, to: afterDate)
        if let days = difference.day {
            differenceResult = "\(abs(days)) days"
        } else {
            differenceResult = "Error"
        }
    }
}


public struct DateAddCalculationDetailView: View {
    
    @State private var year = ""
    @State private var month = ""
    @State private var day = ""
    @State private var duration = ""
    @State private var durationUnit = "day"
    @State private var beforeAfter = "after"

    @State private var resultDate: Date? = nil

    public var body: some View {
     
        VStack(spacing: 10) {
            HStack {
                
                Text("Y")
                TextField("Year", text: $year)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
            
                Text("M")
                TextField("Month", text: $month)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                
                Text("D")
                TextField("Day", text: $day)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                
                Button("Today", action: {
                    let today = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day], from: today)
                    year = "\(components.year ?? 0)"
                    month = "\(components.month ?? 0)"
                    day = "\(components.day ?? 0)"
                })
            }
            
            Spacer().frame(height: 20)

            VStack {
                Picker(selection: $beforeAfter, label: Text("")) {
                    Text("Before").tag("before")
                    Text("After").tag("after")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
                
                Spacer().frame(height: 20)

                TextField("Duration", text: $duration)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                
                Spacer().frame(height: 20)

                Picker(selection: $durationUnit, label: Text("")) {
                    Text("Day").tag("day")
                    Text("Week").tag("week")
                    Text("Month").tag("month")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 240)
            }
            
            Spacer().frame(height: 20)
            
            Button(action: {
                calculateResultDate()
            }) {
                Text("Calculate")
                    .font(.system(size: 16))
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Text("Calculation Result:")
                .font(.system(size: 18))
                .foregroundColor(.black.opacity(0.3))
                .multilineTextAlignment(.center) // Center the text
                .padding(.top)

            if let resultDate = resultDate {
                Text("\(resultDate, formatter: dateFormatter)")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center) // Center the text
            } else {
                Text("Invalid date")
                    .font(.system(size: 18))
                    .foregroundColor(.red) // Show in red color
            }

        }
        .padding()
        Spacer()
    }

    private func clearResultDate() {
        resultDate = nil
    }
    
    private func calculateResultDate() {
        guard let yearInt = Int(year),
              let monthInt = Int(month),
              let dayInt = Int(day),
              let durationInt = Int(duration) else {
            clearResultDate()
            return
        }

        let calendar = Calendar.current

        // Check if any of the input fields is empty or not valid
        if year.isEmpty || month.isEmpty || day.isEmpty || duration.isEmpty {
            clearResultDate()
            return
        }

        var dateComponents = DateComponents()
        dateComponents.year = yearInt
        dateComponents.month = monthInt
        dateComponents.day = dayInt

        guard let inputDate = calendar.date(from: dateComponents) else {
            return
        }

        var durationToAdd: Int

        switch durationUnit {
        case "week":
            durationToAdd = durationInt * 7
        case "month":
            durationToAdd = durationInt * 30 // Approximating months to 30 days
        default:
            durationToAdd = durationInt
        }

        if beforeAfter == "before" {
            durationToAdd *= -1
        }

        if let result = calendar.date(byAdding: .day, value: durationToAdd, to: inputDate) {
            resultDate = result
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }()

}



