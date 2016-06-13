import PerfectLib

let occurBugReport = "哎呀，不好，我出bug啦 (⊙０⊙) "

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

    var notImplementReturn: (Bool,String) {
        return (false, "planManager's method has not been implemented..")
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

    mutating func addWeekPlanFor(_ user: String) -> (Bool, String) {
        print(planDict)
        if let _ = planDict[user] as? [String: Any] {
            return (true, "你之前已经订过工作日的计划了哦,我是不会忘哒（＾ω＾）")
        } else {
            planDict[user] = ["week": true]
            if save() {
                return (true, "工作日点晚餐的工作就交给智能晚饭君啦 (ง •̀_•́)ง")
            } else {
                return (false, occurBugReport)
            }
        }
        //return notImplementReturn
    }
    mutating func cancelWeekPlanFor(_ user: String) -> (Bool, String) {
        if let _ = planDict[user] as? [String: Any] {
            planDict[user] = nil
            if save() {
                return (true, "已经帮你取消了工作日点饭计划，再来哦 ...(｡•ˇ‸ˇ•｡) ...")
            } else {
                return (false, occurBugReport)
            }
        } else {
            return (true, "哎呦，你之前还没有制定过点饭计划哦 (oﾟωﾟo)")
        }
        return notImplementReturn
    }
}

