//
//  TimeZone+Util.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import Foundation

fileprivate let formatter = DateFormatter()
fileprivate let offsetFormatter = DateComponentsFormatter()

extension TimeZone {
    var currentTime: String? {
        formatter.timeZone = self
        formatter.dateFormat = "h:mm"
        
        return formatter.string(from: .now)
    }
    
    var timePeriod:String? {
        formatter.timeZone = self
        formatter.dateFormat = "a"
        
        return formatter.string(from: .now)
        
    }
    
    var city: String? {
        
        // 내코드
//        func parseString(_ input: String, delimiter: Character) -> String? {
//            guard let delimiterRange = input.range(of: String(delimiter)) else {
//                return nil
//            }
//            let startIndex = input.index(after: delimiterRange.lowerBound)
//            let substring = input[startIndex..<input.endIndex]
//            return String(substring)
//        }
//
//        // Asia/Seoul
//        if let parsedString = parseString(identifier, delimiter: "/") {
//            return parsedString
//        } else {
//            return nil
//        }
        
        // 센세 코드
        let city = identifier.components(separatedBy: "/").last
        return city
        
    }
    
    var timeOffset: String? {
        //                     +9                        -      +9            == 0
        // 현재타임존이 서울이고 인스턴스가 뉴욕이라면? + 9         -      -5            == 14
//        let offset = TimeZone.current.secondsFromGMT() - secondsFromGMT()
        // 이래야 제대로 된 시간 계산
        let offset = secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let prefix = offset >= 0 ? "+" : ""
        let comp = DateComponents(second: offset)
        
        
        // 9시간 -7시간
        if offset.isMultiple(of: 3600) {
            offsetFormatter.allowedUnits = [.hour]
            offsetFormatter.unitsStyle = .full
        } else {
            offsetFormatter.allowedUnits = [.hour, .minute]
            offsetFormatter.unitsStyle = .positional
        }
        let offsetStr = offsetFormatter.string(from:comp) ?? "\(offset / 3600)시간"
        
        let time = Date(timeIntervalSinceNow: TimeInterval(offset))
        
        let cal = Calendar.current
        
        if cal.isDateInToday(time) {
            return "오늘 \(prefix)\(offsetStr)"
        } else if cal.isDateInYesterday(time) {
            return "어제 \(prefix)\(offsetStr)"
        } else if cal.isDateInTomorrow(time){
            return "내일 \(prefix)\(offsetStr)"
        } else {
            return nil
        }
    }
}
