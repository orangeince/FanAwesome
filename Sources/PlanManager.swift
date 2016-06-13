import PerfectLib


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
    }
    deinit {
        planFile.close()
    }

    var notImplementReturn: (Bool,String) {
        return (false, "planManager's method has not been implemented..")
    } 

    func addWeekPlanFor(_ user: String) -> (Bool, String) {

        return notImplementReturn
    }
    func cancelWeekPlanFor(_ user: String) -> (Bool, String) {

        return notImplementReturn
    }
}

