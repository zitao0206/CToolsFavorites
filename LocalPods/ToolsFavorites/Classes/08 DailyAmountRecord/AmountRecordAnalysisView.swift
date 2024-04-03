//
//  AmountRecordAnalysisView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-22.
//

import SwiftUI

struct BarChartView: View {
    let data: [Double]
    
    let barWidth: Double = 10
    let barSpacing: Double = 10
    let offsetSpace: Double = 35
    let viewContentHeight: Double = 400
    let viewHeight: Double = 400 + 30
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    // 绘制Y轴
                    path.move(to: CGPoint(x: offsetSpace, y: 0))
                    path.addLine(to: CGPoint(x: offsetSpace, y: viewContentHeight))
                    
                    // 绘制X轴
                    path.move(to: CGPoint(x: offsetSpace, y: viewContentHeight))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: viewContentHeight))
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 2))

                // 绘制Y轴标签
                ForEach(yAxisLabels(), id: \.self) { label in
                    Text(label)
                        .font(.caption)
                        .position(x: 15, y: geometry.size.height - 30 - self.yLabelPosition(label: Double(Int(label)!), maxHeight: viewContentHeight))
                }
                
                // X轴标签
                Text("Days")
                    .font(.caption)
                    .position(x: (geometry.size.width + offsetSpace) / 2.0, y: viewContentHeight + 15)
                
                VStack {
                    // 柱状图部分
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .bottom, spacing: barSpacing) {
                            ForEach(0..<data.count, id: \.self) { index in
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: barWidth, height: self.normalizedHeight(index: index))
                            }
                        }
                    }
                    .padding(.leading, 40)
                    .padding(.bottom, 30)
                
                }
            }
            
        }
        .frame(height: viewHeight)
    }
    
    // 根据数据值和图表最大高度计算柱状图高度
    func normalizedHeight(index: Int) -> Double {
        return data[index] * viewContentHeight / 2000.0 //- data[index] / viewHeight * 10
    }
    
    // 计算Y轴标签的位置
    func yLabelPosition(label: Double, maxHeight: Double) -> Double {
        let maxValue: Double = 2000
        return (label / maxValue) * viewContentHeight
    }
    
    // 生成Y轴标签
    func yAxisLabels() -> [String] {
        stride(from: 500, through: 2000, by: 500).map { "\($0)" }
    }
}

 
struct AmountRecordAnalysisView: View {
    
    @State private var amountRecords: [Date: [AmountRecord]] = [:]
    
    @ObservedObject var cloudKitManager = AmountRecordCloudKitManager.shared
    @ObservedObject var localCacheManager = AmountRecordCacheManager.shared
    
    private var dataManager : any AmountRecordProtocol {
        let databaseName = UserDefaults.standard.string(forKey: UserDefaultsConstants.amountRecordDatabaseIdentifier)
        if let databaseName = databaseName, !databaseName.isEmpty {
            return cloudKitManager
          
        } else {
            return localCacheManager
        }
    }
  

    var body: some View {
        VStack {
            let barChartData = dailyAmount()
            BarChartView(data: barChartData)
                .frame(height: 530)

        }
        .onAppear {
            loadRecords()
        }
        .commmonNavigationBar(title: "History", displayMode: .inline)
  
    }
    
    
    
    private func loadRecords() {
        
        dataManager.fetchRecords(forToday: false)  { records, error in
             if let error = error {
                print("Error fetching feeding records from CloudKit: \(error.localizedDescription)")
             } else if let records = records {
                var groupedRecords: [Date: [AmountRecord]] = [:]
                DispatchQueue.main.async {
                  self.amountRecords = records
                }
             }
         }
    }
    
    private var sortedFeedings: [(key: Date, value: [AmountRecord])] {
        return amountRecords.map { (key: $0.key, value: $0.value.sorted(by: { $0.time < $1.time })) }
                           .sorted(by: { $0.key > $1.key })
    }

    private func dailyAmount() -> [Double] {
        var amounts: [Double] = []
        
        // 遍历 sortedFeedings，计算每一天的总金额并将其添加到 amounts 中
        for (date, records) in sortedFeedings {
            let total = Double(totalAmount(for: date)) // 将整数金额转换为双精度浮点数
            amounts.append(total)
        }
        
        return amounts
    }
    
    private func totalAmount(for date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return amountRecords[startOfDay]?.reduce(0, { $0 + (Int($1.amount) ?? 0) }) ?? 0
    }

  
}

