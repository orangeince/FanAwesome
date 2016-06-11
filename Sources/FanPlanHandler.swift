import cURL
import PerfectLib
import Foundation

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: [])
    }
    
    func match(input: String) -> Bool {
        let matchedCount = regex.numberOfMatches(in: input,
                                            options: [],
                                            range: NSMakeRange(0, input.utf16.count))
        print("matchedCount: \(matchedCount)")
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

func getSubStringAfterFirstCh(_ str: String) -> String {
    if str.isEmpty || str.characters.count == 1 {
        return ""
    }
    return str.substring(from: str.index(after: str.startIndex))
}

func splitCommandStr(_ str: String) -> (Int, String) {
    if str.isEmpty {
        return (0, "")
    }
    let signStr = str.characters.first!
    return (signStr == "-" ? -1 : 1, getSubStringAfterFirstCh(str))
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
            return "^(\\+\\+)|(\\-\\-)$"
        case .WeekDay:
            return "^\\+|\\-[1-5]$"
        case .WeekDayError:
            return "^\\+|\\-(0|[6-9])(\\d)*$"
        case .OffsetDay:
            return "^\\+|\\-(今天)|(明天)|(后天)|(大后天)|(大大后天)$"
        case .OffsetDayError:
            return "^\\+|\\-(昨天)|((大)*前天)|(大(3,)后天)$"
        case .ExplicitDay:
            return "^\\+|\\-([1-9]|(0[1-9])|(1[0-2])).([1-9]|([1-2][0-9])|(3[0-1]))$"
        case .ExplicitDayError:
            return "^\\+|\\-(\\d+).(\\d+)$"
        }
    }
    static func getFanPlanCommandTypeAndConstantFrom(str: String) -> (FanPlanCommandType, Int)? {
        if str =~ Week.checkPattern {
            return (Week, str == "++" ? 0 : -1)
        } else if str =~ WeekDay.checkPattern {
            let n = Int(str)!
            return (WeekDay, n)
        } else if str =~ WeekDayError.checkPattern {
            let n = Int(str)!
            return (WeekDayError, n)
        } else if str =~ OffsetDay.checkPattern {
            let (multiplier, value) = splitCommandStr(str)
            let n = offsetDayDict[value]!
            return (OffsetDay, multiplier * n)
        } else if str =~ OffsetDayError.checkPattern {
            let (multiplier, value) = splitCommandStr(str)
            let n = str.characters.contains("后") ? 0 : -1
            return (OffsetDayError, multiplier * n)
        } else if str =~ ExplicitDay.checkPattern {
            let (multiplier, value) = splitCommandStr(str)
            let nums = explodedString(str: value, bySeparator: ".")
            var n = 0
            if nums.count == 2 {
                n = Int(nums[0])! * 100 + Int(nums[1])!
            }
            return (ExplicitDay, multiplier * n)
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
        //let theKey = user + "-plan"
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
        print("CommandMode Init... commandStr: \(commandStr)")
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
//
var commands: [FanPlanCommand] = []
var others: [String] = []
var isHelpOthers = false
var responseStr = ""
let commandHelpStr = "***偶尔忘记点饭而挨饿?忘记取消点饭而浪费粮食?让智能晚饭君来拯救你！\n自从有了智能晚饭君，麻麻再也不用担心我的晚饭啦。\n晚饭君使用指南:***" + "\n###fanplan\n- `fanplan ++` or `fanplan --`    每个工作日自动点饭 or 不自动点饭 \n- `fanplan +n` or `fanplan -n`    n = [1, 5] 每周n点饭 or 不点饭  例如: fanplan +1\n- `fanplan +今天` or `fanplan -今天`    明天点饭 or 不点饭\n- `fanplan +明天` or `fanplan -明天`    明天点饭 or 不点饭\n- `fanplan +后天` or `fanplan -后天`    后天点饭 or 不点饭\n- `fanplan +大后天` or `fanplan -大后天`    大后天点饭 or 不点饭\n- `fanplan +大大后天` or `fanplan -大大后天`    大大后天点饭 or 不点饭\n- `fanplan +Month.day` or `fanplan -Month.day`    Month.day那天点饭 or 不点饭\n- `fanplan XX help 某某`    帮某某自动点饭或者取消点饭 XX为以上任意命令"

class FanPlanHandler {
    static func handleFanPlanWith(commandStr: String, userName: String) -> String {
        if commandStr == "fanplan" {
            return commandHelpStr
        }
        var strs = explodedString(str: commandStr, bySeparator: " ")
        strs.removeFirst()
        for commandStr in strs {
            let cmd = CommandMode(commandStr: commandStr)
            switch(cmd) {
            case .UserName(let name):
                others.append(name)
            case .Help:
                isHelpOthers = true
            case .FanPlan(let cmd):
                commands.append(cmd)
            default:
                break
            }
        }
        if commands.isEmpty {
            return "命令解析失败，请参考命令手册输入正确的命令。输入`fanplan`查看命令手册"
        }
        if others.isEmpty {
            others.append(userName)
        }
        for other in others {
            for cmd in commands {
                let (success, report) = cmd.executedReport(user: other)
                if !success {
                    responseStr = report
                    break
                } else {
                    responseStr += report
                }
            }
        }
        return responseStr
    }
}