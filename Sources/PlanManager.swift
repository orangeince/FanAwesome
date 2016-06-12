import PerfectLib


struct PlanManager {
    var planDict: [String: Any] 
    init?() {
        let planFile = File("./plan.config")
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
        guard var configJSON = try? configString.jsonDecode() else {
            print("configString jsonDecoded failed....")
            return nil
        }
        guard var configDict = configJSON as? [String: Any] else {
            print("configDict initial failed.....")
            return nil
        }
        self.planDict = configDict
    }
}

