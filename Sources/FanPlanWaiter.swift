import PerfectLib
import Foundation

guard let manager = PlanManager() else {
    return
}

var orderedUser: [String] = []
let (today, weekday) = getFormattedDateOf(NSDate())
let planDict = manager.planDict
for (user, plan) in planDict {
    if let plan = plan as? [String: Any] {
        if let exceptExplicitDayPlan = convertIntArray(plan["exceptExplicitDay"]) {
            if exceptExplicitDayPlan.contains(today) {
                print("\(user) exceptDay: \(today)")
                continue
            }
        }
        if let exceptWeekDayPlan = convertIntArray(plan["exceptWeekDay"]) {
            if exceptWeekDayPlan.contains(weekday) {
                print("\(user) exceptWeekday:\(weekday)")
            }
        }
        if let explicitDayPlan = convertIntArray(plan["explicitDay"]) {
            if explicitDayPlan.contains(today) {
                print("explicitDayPlan: need order for \(user)")
                orderedUser.append(user)
                continue
            }
        }
        if let weekdayPlan = convertIntArray(plan["weekDay"]) {
            if weekdayPlan.contains(weekday) {
                print("weekdayPlan: need order for \(user)")
                orderedUser.append(user)
                continue
            }
        }
        if let weekPlan = plan["week"] as? Bool {
            if weekPlan == true {
                print("weekplan: need order for \(user)")
                orderedUser.append(user)
                continue
            } else {
                print("weekplan: not order for \(user)")
                continue
            }
        }
    }
}
print(orderedUser)