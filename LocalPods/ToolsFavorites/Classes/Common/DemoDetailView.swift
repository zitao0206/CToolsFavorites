//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AVKit
import Photos



public struct DemoDetailView: View {

    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
             
        }
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {

        }
    }
}



/*Markdown Editor View*/


import MarkdownKit

struct MarkdownEditorView: View {
    @State private var markdownText: String = """
    # OSCHINA.NET社区
    ### Header 3
    ## This is an H2 in a blockquote
    """

    var body: some View {
        VStack {
            TextEditor(text: $markdownText)
                .padding()

            MarkdownView(markdownText: markdownText)
                .padding()
        }
    }
}

struct MarkdownView: View {
    let markdownText: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                MarkdownTextView(markdownText: markdownText)
                    .font(.body)
                    .padding()
            }
        }
    }
}

struct MarkdownTextView: UIViewRepresentable {
    let markdownText: String

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
     
        return label
    }

    func updateUIView(_ label: UILabel, context: Context) {
        let markdownParser = MarkdownParser()
        do {
            let attributedString = try markdownParser.parse(markdownText)
            label.attributedText = attributedString
        } catch {
            print("Error rendering Markdown: \(error)")
            label.text = markdownText
        }
    }
}


/*Blood Pressure*/

struct BloodPressureRecord: Identifiable, Codable {
    let id = UUID()
    let systolic: Int // 收缩压
    let diastolic: Int //舒张压
    let date: Date // 记录日期
}

public struct BloodPressureRecordDetailView: View {

    @State private var systolic: String = ""
    @State private var diastolic: String = ""
    @State private var records: [BloodPressureRecord] = [] // 血压记录数组
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }

    public var body: some View {
        VStack {
            TextField("收缩压", text: $systolic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("舒张压", text: $diastolic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: addRecord) {
                Text("添加记录")
            }
            .padding()
            
            List(records) { record in
                VStack(alignment: .leading) {
                    Text("收缩压: \(record.systolic)")
                    Text("舒张压: \(record.diastolic)")
                    Text("日期: \(formattedDate(date: record.date))")
                }
            }
            .padding()
        }
        .navigationBarTitle("血压记录")
        .onAppear() {
            loadRecords()
        }
    }
    
    func addRecord() {
        guard let systolicValue = Int(systolic),
              let diastolicValue = Int(diastolic) else {
            return
        }
        let record = BloodPressureRecord(systolic: systolicValue, diastolic: diastolicValue, date: Date())
        records.append(record)
        saveRecords()
        // 清空输入
        systolic = ""
        diastolic = ""
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func saveRecords() {
            do {
                let data = try JSONEncoder().encode(records)
                UserDefaults.standard.set(data, forKey: "bloodPressureRecords")
            } catch {
                print("Error saving records: \(error.localizedDescription)")
            }
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





 

