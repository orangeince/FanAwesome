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

func explodedString(str: String, bySeparator: Character) -> [String] {
    return str.characters.split{ $0 == bySeparator }.map{ String($0) }
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
            let n = Int(str.substring(from: str.index(after: str.startIndex)))!
            return (WeekDay, n)
        } else if str =~ WeekDayError.checkPattern {
            let n = Int(str.substring(from: str.index(after: str.startIndex)))!
            return (WeekDayError, n)
        } else if str =~ OffsetDay.checkPattern {
            let n = offsetDayDict[str]!
            return (OffsetDay, n)
        } else if str =~ OffsetDayError.checkPattern {
            let n = str.characters.contains("后") ? 0 : -1
            return (OffsetDayError, n)
        } else if str =~ ExplicitDay.checkPattern {
            let nums = explodedString(str: str, bySeparator: ".")
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

struct FanPlanCommand {
    var type: FanPlanCommandType
    var constant: Int
    static func getCommandFrom(str: String) -> FanPlanCommand? {
        if let (type, constrant) = FanPlanCommandType.getFanPlanCommandTypeAndConstantFrom(str: str) {
            return FanPlanCommand(type: type, constant: constrant)
        }
        return nil
    }
    
    func executedReport(user: String) -> (Bool, String) {
        let theKey = user + "-plan"
        var success = true
        var report = ""
        switch type {
        case .Week:
            if constant < 0 {

            } else {
                
            }
        case .ExplicitDayError:
            success = false
            report = "指定的日期格式不对"
        default:
            return (false, "Command hasn't be executed")
        }
        return (success, report)
    }
}

enum CommandMode {
    case FanPlan(FanPlanCommand)
    case UserName(String)
    case UnKnown
    case Help
    init(commandStr: String) {
        if userlist.contains(commandStr) {
            self = .UserName(commandStr)
        } else if commandStr == "help" {
            self = .Help
        } else if let fanplanCommand = FanPlanCommand.getCommandFrom(str: commandStr) {
            self = .FanPlan(fanplanCommand)
        } else {
            self = .UnKnown
        }
    }
}

class FanPlanHandler {
    static func handleFanPlanWith(commandStr: String, userName: String) -> String {
        return ""
    }
}