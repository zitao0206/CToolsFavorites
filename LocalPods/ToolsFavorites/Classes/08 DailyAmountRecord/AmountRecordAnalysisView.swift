//
//  AmountRecordAnalysisView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-22.
//

import SwiftUI

struct BarChartView: View {
    let data: [CGFloat]
    
    let barWidth: CGFloat = 10
    let barSpacing: CGFloat = 10  

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    // 绘制Y轴
                    path.move(to: CGPoint(x: 30, y: 0))
                    path.addLine(to: CGPoint(x: 30, y: geometry.size.height - 30))
                    
                    // 绘制X轴
                    path.move(to: CGPoint(x: 30, y: geometry.size.height - 30))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - 30))
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 2))

                // 绘制Y轴标签
                ForEach(yAxisLabels(), id: \.self) { label in
                    Text(label)
                        .font(.caption)
                        .position(x: 15, y: geometry.size.height - 30 - self.yLabelPosition(label: CGFloat(Int(label)!), maxHeight: geometry.size.height - 30))
                }
                
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
                    .padding(.leading, 35)
                    .padding(.bottom, 5)
                    
                    // X轴标签
                    Text("Days")
                        .font(.caption)
                        .padding(.top, 5)
                }
            }
            
        }
        .frame(height: 300)
    }
    
    // 根据数据值和图表最大高度计算柱状图高度
    func normalizedHeight(index: Int) -> CGFloat {
        return data[index] - data[index] / 50 * 5
    }
    
    // 计算Y轴标签的位置
    func yLabelPosition(label: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let maxValue: CGFloat = 300 // 假设Y轴最大值为300
        return (label / maxValue) * maxHeight
    }
    
    // 生成Y轴标签
    func yAxisLabels() -> [String] {
        stride(from: 50, through: 300, by: 50).map { "\($0)" }
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
     
            BarChartView(data: [50, 100, 150, 200, 250, 300, 60, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250, 50, 100, 200, 150, 200, 250])
                .frame(height: 300)

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

    
    private func totalAmount(for date: Date) -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return amountRecords[startOfDay]?.reduce(0, { $0 + (Int($1.amount) ?? 0) }) ?? 0
    }

  
}

