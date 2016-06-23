import PerfectLib

let occurBugReport = "哎呀，不好，粗bug啦 (⊙０⊙) "
let saveFailedReport = (false, occurBugReport)
let notImplementedReport = (false, "planManager's method has not been implemented..")

struct PlanManager {
    var planDict: [String: Any] 
    let planFile: File
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
        print(planDict)
        if var plan = planDict[user] as? [String: Any] {
            if let hasWeekPlan = plan["week"] as? Bool where hasWeekPlan == true {
                return (true, "\(user)之前已经订过工作日的计划了哦,我是不会忘哒（＾ω＾）")
            } else {
                plan["week"] = true
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
        if let plan = planDict[user] as? [String: Any] {
            if let hasWeekPlan = plan["week"] as? Bool where hasWeekPlan == true {
                if var exceptWeekDayPlan = plan["exceptWeekDay"] as? [Int] {
                    if let idx = exceptWeekDayPlan.index(of: day) {
                        exceptWeekDayPlan.remove(at: idx)
                        if save() {
                            return (true, "TODO: success...")
                        } else {
                            return saveFailedReport
                        }
                    }
                }
                return (true, "TODO, yi jing you le gongzuori jihua bu xuyao zai.. ")
            }
            if var weekDayPlan = plan["weekDay"] as? [Int] {
                if weekDayPlan.contains(day) {
                    return (true, "TODO,yi jing tian jia guo ci jihua")
                }
                weekDayPlan.append(day)
                if var exceptWeekDayPlan = plan["exceptWeekDay"] as? [Int] {
                    if let idx = exceptWeekDayPlan.index(of: day) {
                        exceptWeekDayPlan.remove(at: idx)
                    }
                }
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
        if let _ = planDict[user] as? [String: Any] {
            return notImplementedReport
        } else {
            planDict[user] = ["exceptWeekDay": [day]]
            if save() {
                return (true, "TODO: cancelWeekDayPlan success...")
            } else {
                return saveFailedReport
            }
        }
    }
}

