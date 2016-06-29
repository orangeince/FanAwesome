import PerfectLib
import Foundation

let occurBugReport = "哎呀，不好，粗bug啦 (⊙０⊙) "
let saveFailedReport = (false, occurBugReport)
let notImplementedReport = (false, "planManager's method has not been implemented..")

//制定计划的type
enum PlanType {
    case Add    //添加计划
    case Cancel //取消计划
}

struct PlanManager {
    var planDict: [String: Any] 
    let planFile: File

    struct PlanKeySuit {
        let planKey: String
        let opposedPlanKey: String
    }
    init?() {
        planFile = File("./plan.config")
        print("plan path: \(planFile.path)")
        guard let _ = try? planFile.open(.readWrite) else {
            print("open file failed..")
            return nil
        }
        guard var configString = try? planFile.readString() else {
            print("read configstring failed...")
            return nil
        }

        if configString.isEmpty {
            configString = "{\"initialized\": true}"
        }
        guard let configJSON = try? configString.jsonDecode() else {
            print("configString jsonDecoded failed....")
            return nil
        }
        guard let configDict = configJSON as? [String: Any] else {
            print("configDict initial failed.....")
            return nil
        }
        self.planDict = configDict
        planFile.close()
        print(planDict)
    }

    func save() -> Bool {
        print("save plan ing.....")
        print("plan: \(planDict)")
        if let jsonString = try? planDict.jsonEncodedString() {
            try! planFile.open(.write)
            defer {
                planFile.close()
            }
            if let _ = try? planFile.write(string: jsonString) {
                return true
            }
            print("plan write failed...")
            return false
        }
        print("dictionary jsonencode failed...")
        return false
    }

    /*
     * TODO: need add comment
     */
    mutating func addWeekPlanFor(_ user: String) -> (Bool, String) {
        if var plan = planDict[user] as? [String: Any] {
            if let hasWeekPlan = plan["week"] as? Bool where hasWeekPlan == true {
                return (true, "\(user)之前已经订过工作日的计划了哦,我是不会忘哒（＾ω＾）")
            } else {
                plan["week"] = true
                planDict[user] = plan
                if save() {
                    return (true, "\(user)工作日点晚餐的工作就交给智能晚饭君啦 (ง •̀_•́)ง")
                } else {
                    return saveFailedReport
                }
            }
        } else {
            planDict[user] = ["week": true]
            if save() {
                FlanHelper.fanOrderFor(user)
                return (true, "\(user)工作日点晚餐的工作就交给智能晚饭君啦 (ง •̀_•́)ง")
            } else {
                return saveFailedReport
            }
        }
    }
    mutating func cancelWeekPlanFor(_ user: String) -> (Bool, String) {
        if var plan = planDict[user] as? [String: Any] {
            if plan["week"] == nil || plan["week"]! as! Bool == false {
                return (true, "哎呦，\(user)之前还没有制定过点饭计划哦 (oﾟωﾟo)")
            }
            plan["week"] = false
            planDict[user] = plan
            if save() {
                FlanHelper.cancelFanOrderFor(user)
                return (true, "已经帮\(user)取消了工作日点饭计划，再来哦 ...(｡•ˇ‸ˇ•｡) ...")
            } else {
                return (false, occurBugReport)
            }
        } else {
            return (true, "哎呦，\(user)之前还没有制定过点饭计划哦 (oﾟωﾟo)")
        }
    }
    mutating func addWeekDayPlanFor(_ user: String, withDay day: Int) -> (Bool, String) {
        if var plan = planDict[user] as? [String: Any] {
            if let hasWeekPlan = plan["week"] as? Bool where hasWeekPlan == true {
                if var exceptWeekDayPlan = convertIntArray(plan["exceptWeekDay"]) {
                    if let idx = exceptWeekDayPlan.index(of: day) {
                        exceptWeekDayPlan.remove(at: idx)
                        plan["exceptWeekDay"] = exceptWeekDayPlan
                        planDict[user] = plan
                        if save() {
                            return (true, "TODO: success...")
                        } else {
                            return saveFailedReport
                        }
                    }
                }
                return (true, "TODO, yi jing you le gongzuori jihua bu xuyao zai.. ")
            }
            if var weekDayPlan = convertIntArray(plan["weekDay"]) {
                if weekDayPlan.contains(day) {
                    return (true, "TODO,yi jing tian jia guo ci jihua")
                }
                if var exceptWeekDayPlan = convertIntArray(plan["exceptWeekDay"]) {
                    if let idx = exceptWeekDayPlan.index(of: day) {
                        exceptWeekDayPlan.remove(at: idx)
                        plan["exceptWeekDay"] = exceptWeekDayPlan
                        planDict[user] = plan
                    }
                }
                weekDayPlan.append(day)
                plan["weekDay"] = weekDayPlan
                planDict[user] = plan
                if save() {
                    return (true, "TODO, append weekDay plan success...")
                } else {
                    return saveFailedReport
                }
            } else {
                print("debugtag: not hasWeekDayPlan...")
                plan["weekDay"] = [day]
                planDict[user] = plan
                if save() {
                    return (true, "TODO, success...")
                } else {
                    return saveFailedReport
                }
            }
        } else {
            planDict[user] = ["WeekDay": [day]]
            if save() {
                return (true, "TODO: addWeekDayPlan success...")
            } else {
                return saveFailedReport
            }
        }
    }
    mutating func cancelWeekDayPlanFor(_ user: String, withDay day: Int) -> (Bool, String) {
        if var plan = planDict[user] as? [String: Any] {
            if var exceptWeekDayPlan = convertIntArray(plan["exceptWeekDay"]) {
                if exceptWeekDayPlan.contains(day) {
                    return (true, "TODO, yijing tianjia youguo ci jihuala")
                }
                if var weekDayPlan = convertIntArray(plan["weekDay"]) {
                    if let idx = weekDayPlan.index(of: day) {
                        weekDayPlan.remove(at: idx)
                        plan["weekDay"] = weekDayPlan
                    }
                }
                exceptWeekDayPlan.append(day)
                plan["exceptWeekDay"] = exceptWeekDayPlan
                planDict[user] = plan
                if save() {
                    return (true, "TODO, append exceptWeekDayPlan successs..")
                } else {
                    return saveFailedReport
                }
            } else {
                plan["exceptWeekDay"] = [day]
                planDict[user] = plan
                if save() {
                    return (true, "TODO, xin jian exceptWeekDayPlan success...")
                } else {
                    return saveFailedReport
                }
            }
        } else {
            planDict[user] = ["exceptWeekDay": [day]]
            if save() {
                return (true, "TODO: cancelWeekDayPlan success...")
            } else {
                return saveFailedReport
            }
        }
    }

    mutating func addOffsetDayPlanFor(_ user: String, withOffset offset: Int) -> (Bool, String) {
        if offset == 0 {
            FlanHelper.fanOrderFor(user)
            return (true, "OK,今天的饭已经帮你点上啦")
        }
        let day = 0
        let keySuit = PlanKeySuit(planKey: "explicitDay", opposedPlanKey: "exceptExplicitDay")
        return makePlanFor(user, withDay: day, keySuit: keySuit)
    }

    mutating func cancelOffsetDayPlanFor(_ user: String, withOffset offset: Int) -> (Bool, String) {
        if offset == 0 {
            FlanHelper.cancelFanOrderFor(user)
            return (true, "OK,今天的饭已经帮你取消喽")
        }
        let day = 0
        let keySuit = PlanKeySuit(planKey: "exceptExplicitDay", opposedPlanKey: "explicitDay")
        return makePlanFor(user, withDay: day, keySuit: keySuit)
    }

    mutating func addExplicitDayPlanFor(_ user: String, withDay day: Int) -> (Bool, String) {
        let today = getFormattedDateOfToday()
        print("today: \(today)")
        if day < today {
            return (false, "指定的日期是过去的时间哦，请确认日期")
        } else if day == today {
            FlanHelper.fanOrderFor(user)
            return (true, "ok,今天的饭已经帮你点上了哦")
        }
        let keySuit = PlanKeySuit(planKey: "explicitDay", opposedPlanKey: "exceptExplicitDay")
        return makePlanFor(user, withDay: day, keySuit: keySuit)
    }

    mutating func cancelExplicitDayPlanFor(_ user: String, withDay day: Int) -> (Bool, String) {
        let keySuit = PlanKeySuit(planKey: "exceptExplicitDay", opposedPlanKey: "explicitDay")
        return makePlanFor(user, withDay: day, keySuit: keySuit)
    }

    mutating func makePlanFor(_ user: String, withDay day: Int, keySuit: PlanKeySuit) -> (Bool, String) {
        let planKey = keySuit.planKey
        let opposedPlanKey = keySuit.opposedPlanKey

        if var plan = planDict[user] as? [String: Any] {
            if var originPlan = convertIntArray(plan[planKey]) {
                if originPlan.contains(day) {
                    return (true, "已经制定过此计划哦")
                }
                if var opposedPlan = convertIntArray(plan[opposedPlanKey]) {
                    if let idx = opposedPlan.index(of: day) {
                        opposedPlan.remove(at: idx)
                        plan[opposedPlanKey] = opposedPlan
                        planDict[user] = plan
                    }
                }
                originPlan.append(day)
                plan[planKey] = originPlan
                planDict[user] = plan
                if save() {
                    return (true, "OK,计划添加成功")
                } else {
                    return saveFailedReport
                }
            } else {
                if var opposedPlan = convertIntArray(plan[opposedPlanKey]) {
                    if let idx = opposedPlan.index(of: day) {
                        opposedPlan.remove(at: idx)
                        plan[opposedPlanKey] = opposedPlan
                        planDict[user] = plan
                    }
                }
                plan[planKey] = [day]
                planDict[user] = plan
                if save() {
                    return (true, "OK, 新建计划成功")
                } else {
                    return saveFailedReport
                }
            }
        } else {
            planDict[user] = [planKey : [day]]
            if save() {
                return (true, "新建订饭计划成功")
            } else {
                return saveFailedReport
            }
        }
    }

    func convertIntArray(_ any: Any?) -> [Int]? {
        if let anyArr = any as? [Any] {
            return anyArr.reduce([Int]()) {
                intArry, any in
                if let i = any as? Int {
                    return intArry + [i]
                }
                return intArry
            }
        }
        return nil
    }
}
func getFormattedDateOfToday() -> Int {
    let today = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let dateComponents = calendar.components([.day, .month], from: today)!
    return dateComponents.month * 100 + dateComponents.day
}

