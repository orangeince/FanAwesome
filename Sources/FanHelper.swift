import PerfectCURL
import cURL

class FlanHelper {
    static func fanOrderFor(_ user: String) {
        let postString = "\"text\": \"fan +1 \(user)\""
        performRequestWith(postString)
    }
    static func cancelFanOrderFor(_ user: String) {
        let postString = "\"text\": \"fan -1 \(user)\""
        performRequestWith(postString)
    }
    static func performRequestWith(_ postString: String) {
        let cUrl = CURL(url: "https://hook.bearychat.com/=bw85y/incoming/1d6cc882252511592d627cfab2bfe99d")
        _ = cUrl.setOption(CURLOPT_HTTPHEADER, s: "Content-Type: application/json")
        _ = cUrl.setOption(CURLOPT_POSTFIELDS, s: postString)
        cUrl.perform{
            code, header, body in
            if code == 0 {
                print("performRequest Success!! body:\(body) post: \(postString)")
            } else {
                let response = cUrl.responseCode
                print("performRequest failed... code: \(response) post: \(postString)")
            }
        }
    }
}