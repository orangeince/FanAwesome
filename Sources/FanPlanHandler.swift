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

class FanPlanHandler {
    static func handleFanPlanWith(commandStr: String, userName: String) -> String {
        return ""
    }
}