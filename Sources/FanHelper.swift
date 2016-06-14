import PerfectCURL
import cURL

class FlanHelper {
    static func fanOrderFor(_ user: String) {
        //let postString = "{\"text\":\"fan 1 \(user)\"}"
        let postString = "fanfanfan"
        performRequestWith(postString)
    }
    static func cancelFanOrderFor(_ user: String) {
        //let postString = "{\"text\":\"fan -1 \(user)\"}"
        let postString = "notfanfanfan"
        performRequestWith(postString)
    }
    static func performRequestWith(_ postString: String) {
        //let cUrl = CURL(url: "https://hook.bearychat.com/=bw85y/incoming/1d6cc882252511592d627cfab2bfe99d")
        let cUrl = CURL(url: "http://182.92.65.174:8181")
        _ = cUrl.setOption(CURLOPT_HTTPHEADER, s: "Content-Type: application/json")
        _ = cUrl.setOption(CURLOPT_POST, int: 1)
        _ = cUrl.setOption(CURLOPT_POSTFIELDS, s: postString)
        _ = cUrl.setOption(CURLOPT_POSTFIELDSIZE, int: postString.utf8.count)
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