import cURL

class FlanHelper {
    static var cUrl = CURL("https://hook.bearychat.com/=bw85y/incoming/1d6cc882252511592d627cfab2bfe99d")
    static func fanOrderFor(_ user: String) {
        let postString = "\"text\": \"fan +1 \(user)\""
        performRequestWith(postString)
    }
    static func cancelFanOrderFor(_ user: String) {
        let postString = "\"text\": \"fan -1 \(user)\""
        performRequestWith(postString)
    }
    static func performRequestWith(_ postString: String) {
        cUrl.setOption(CURLOPT_HTTPHEADER, s: "Content-Type: application/json")
        cUrl.setOption(CURLOPT_POSTFIELDS, s: postString)
        cUrl.perform{
            code, header, body in
            if code == 0 {
                print("performRequest Success!! post: \(postString)")
            } else {
                let respose = curl.resposeCode
                print("performRequest failed... code: \(respose) post: \(postString)")
            }
        }
    }
}