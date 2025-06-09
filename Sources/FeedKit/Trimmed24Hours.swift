import Foundation

struct Trimmed24Hours {
    static func expression(_ date: String) -> String? {
        var trimmedString = date
        let pattern = #"([A-Za-z]{3}, \d{2} [A-Za-z]{3} \d{4}) 24:([0-5][0-9]:[0-5][0-9])"#
                  let regex = try? NSRegularExpression(pattern: pattern)

        if let match = regex?.firstMatch(in: trimmedString, range: NSRange(trimmedString.startIndex..., in: trimmedString)) {
            if let dateRange = Range(match.range(at: 1), in: trimmedString),
               let timeSuffixRange = Range(match.range(at: 2), in: trimmedString) {
                
                let datePart = String(trimmedString[dateRange])
                let timeSuffix = String(trimmedString[timeSuffixRange]) // ex: "28:33"
                
                // 기존 날짜 파싱
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "EEE, dd MMM yyyy"
                
                if let date = formatter.date(from: datePart) {
                    // 하루 뒤 날짜
                    let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    let newDatePart = formatter.string(from: nextDay)
                    
                    // "24:xx:xx" → "00:xx:xx" 으로 바꾸고 날짜도 교체
                    trimmedString = trimmedString.replacingOccurrences(
                        of: "\(datePart) 24:\(timeSuffix)",
                        with: "\(newDatePart) 00:\(timeSuffix)"
                    )
                    
                    return trimmedString
                }
            }
        }
        
        return nil
    }
}
