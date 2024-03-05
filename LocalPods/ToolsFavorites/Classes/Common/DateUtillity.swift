//
//  Common.swift
//  BabyDailyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

public class DateUtillity {
    public static func formattedDateToMMDD(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    public static func formattedDateToHHMM(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

 
