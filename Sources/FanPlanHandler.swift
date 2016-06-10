import cURL
import PerfectLib
import Foundation

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matchedCount = regex.numberOfMatches(in: input,
                                            options: [],
                                            range: NSMakeRange(0, input.utf16.count))
        return matchedCount > 0
    }
}

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(input: lhs)
    } catch _ {
        return false
    }
}

let userlist = ["OI"]


let offsetDayDict = ["今天":0, "明天":1, "后天": 2, "大后天": 3, "大大后天":4]

struct UserConfig {
    var weekDay: [Int] = []
    var weekDayExcept: [Int] = []
    var date: [NSDate] = []
    var dateExcept: [NSDate] = []
}

enum FanPlanCommandType {
    case Week
    case WeekDay
    case WeekDayError
    case OffsetDay
    case OffsetDayError
    case ExplicitDay
    case ExplicitDayError
    
    var checkPattern: String {
        switch self {
        case .Week:
            return "++|--"
        case .WeekDay:
            return "+|-[1-5]"
        case .WeekDayError:
            return "+|-(0|[6-9])(\\d)*"
        case .OffsetDay:
            return "今天|明天|后天|大后天|大大后天|大大大后天"
        case .OffsetDayError:
            return "昨天|(大)*前天|大(4,)后天"
        case .ExplicitDay:
            return "([1-9]|0[1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1])"
        case .ExplicitDayError:
            return "(\\d+).(\\d+)"
        }
    }
    static func getFanPlanCommandTypeAndConstantFrom(str: String) -> (FanPlanCommandType, Int)? {
        if str =~ Week.checkPattern {
            return (Week, 0)
        } else if str =~ WeekDay.checkPattern {
            let n = Int(str.substringFromIndex(str.startIndex.successor()))!
            return (WeekDay, n)
        } else if str =~ WeekDayError.checkPattern {
            let n = Int(str.substringFromIndex(str.startIndex.successor()))!
            return (WeekDayError, n)
        } else if str =~ OffsetDay.checkPattern {
            let n = offsetDayDict[str]!
            return (OffsetDay, n)
        } else if str =~ OffsetDayError.checkPattern {
            let n = str.characters.contains("后") ? 0 : -1
            return (OffsetDayError, n)
        } else if str =~ ExplicitDay.checkPattern {
            let nums = explodedString(str, bySeparator: ".")
            var n = 0
            if nums.count == 2 {
                n = Int(nums[0])! * 100 + Int(nums[1])!
            }
            return (ExplicitDay, n)
        } else if str =~ ExplicitDayError.checkPattern {
            return (ExplicitDayError, 0)
        } else {
            return nil
        }
    }
}

class FanPlanHandler {
    static func handleFanPlanWith(commandStr: String, userName: String) -> String {
        return ""
    }
}