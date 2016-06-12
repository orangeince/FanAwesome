import PerfectLib


struct PlanManager {
    var planDict: [String: Any] 
    init?() {
        guard let planFile = try? File(fd: "./plan.config", .readWrite) else {
            print("read file failed..")
            return nil
        }
        guard var configString = planFile.readString() else {
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

