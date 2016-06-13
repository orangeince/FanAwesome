import PerfectCURL
import cURL

class FlanHelper {
    static func fanOrderFor(_ user: String) {
        let postString = "{\"text\": \"fan +1 \(user)\"}"
        performRequestWith(postString)
    }
    static func cancelFanOrderFor(_ user: String) {
        let postString = "{\"text\": \"fan -1 \(user)\"}"
        performRequestWith(postString)
    }
    static func performRequestWith(_ postString: String) {
        //let cUrl = CURL(url: "https://hook.bearychat.com/=bw85y/incoming/1d6cc882252511592d627cfab2bfe99d")
        let cUrl = CURL(url: "http://182.92.65.174:8181")
        _ = cUrl.setOption(CURLOPT_HTTPHEADER, s: "Content-Type: application/json")
        let v = curl_easy_escape(cUrl.curl!, postString, 0)
        _ = cUrl.setOption(CURLOPT_POSTFIELDS, v: v)
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