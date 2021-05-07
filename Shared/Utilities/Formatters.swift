//
//  Formatters.swift
//  MyYouTube
//
//  Created by pgc6240 on 07.05.2021.
//

import Foundation

enum F { // MARK: - Formatters -
    
    static let df1: DateFormatter = {
        let df       = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    
    
    static let df2: DateFormatter = {
        let df       = DateFormatter()
        df.dateStyle = .full
        return df
    }()
    
    
    static let df3 = DateFormatter()
    
    
    static let nf: NumberFormatter = {
        let nf               = NumberFormatter()
        nf.numberStyle       = .decimal
        nf.groupingSeparator = ","
        return nf
    }()
    
    
    /// Time formatter.
    static let tf1: DateComponentsFormatter = {
        let tf                    = DateComponentsFormatter()
        tf.allowedUnits           = [.second, .minute, .hour]
        tf.unitsStyle             = .positional
        tf.zeroFormattingBehavior = .pad
        return tf
    }()
    
    
    /// Second time formatter.
    static let tf2: DateComponentsFormatter = {
        let tf                    = DateComponentsFormatter()
        tf.allowedUnits           = [.second, .minute]
        tf.unitsStyle             = .positional
        tf.zeroFormattingBehavior = .pad
        return tf
    }()
}

 
// MARK: - Methods -
extension F {
    
    /// 2021-03-22 09:55:26 +0000 -> "понедельник, 22 марта 2021 г."
    static func formatDate(_ date: Date) -> String {
        df1.string(from: date)
    }
    
    
    /// "1000000" -> "1,000,000"
    static func formatNumber(_ string: String) -> String {
        guard let number = nf.number(from: string) else { return string }
        return nf.string(from: number) ?? string
    }
    
    
    /// 307.651327 -> "5:07"
    static func formatTime(_ float: Float?) -> String {
        if float == -1 {
            return "LIVE"
        }
        let ti = TimeInterval(float ?? 0)
        return (ti > 3600 ? tf1.string(from: ti) : tf2.string(from: ti)) ?? "00:00"
    }
    
    
    /// "PT1H35M19S" -> 5719.000_000
    static func formatDuration(_ string: String?) -> Float? {
        guard let string = string else { return nil }
        guard string != "P0D" else { return -1 }
        let dateFormats = ["'PT'HH'H'mm'M'ss'S'", "'PT'mm'M'ss'S'", "'PT'mm'M'", "'PT'ss'S'", "'PT'HH'H'mm'M'",
                           "'PT'HH'H'ss'S'", "'PT'HH'H'", "'PT'H'H'mm'M'ss'S'", "'PT'H'H'm'M'ss'S'", "'PT'H'H'",
                           "'PT'mm'M's'S'", "'PT'mm'M'ss'S'", "'PT'mm'M'", "'PT'ss'S'", "'PT'H'H'ss'S'"]
        for dateFormat in dateFormats {
            df3.dateFormat = dateFormat
            guard let date = df3.date(from: string) else { continue }
            let hours = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            let seconds = Calendar.current.component(.second, from: date)
            return Float(hours * 60 * 60 + minutes * 60 + seconds)
        }
        #if DEBUG
        print(#function, string)
        #endif
        return nil
    }
}
