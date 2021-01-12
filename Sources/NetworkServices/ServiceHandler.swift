//
//  ServiceHandler.swift
//  Network
//
//  Created by Nithin R on 23/12/20.
//


/// constants for url request type
let kGet = "GET"
let kPost = "POST"
let kSource = "POST"
let kPut = "PUT"

import Foundation

public class ServiceHandler {
        
    public class func executeServiceCall<T: Decodable>(urlString: String?,requesType:String?,requestParam:Codable?,_ additionalHeader:[String: String]?, completion: @escaping (T?,_ error:Error?,_ statusCode:Int?) -> ()) {
        var param:[String:Any]?
        do
        {
            param = try requestParam?.asDictionary()
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        let url = URL(string: urlString ?? "")
        
        if let request = self.createRequest(requesType: requesType, url: url, param: param,additionalHeader:additionalHeader)
        {
            let cookie = returnCookie(url: url)
            URLSession.shared.dataTask(with: request) { (data, resp, err) in
                var statusCode:Int?
                if(cookie != nil)
                {
                    self.setPassedCookieSource(cookie: cookie!)
                }
                if let httpResponse = resp as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                if let err = err {
                    print("Failed to fetch data:", err)
                    completion(nil, err, statusCode)
                    
                    return
                }
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let obj:T? = try decoder.decode(T.self, from: data)
                    completion(obj, nil, statusCode)
                } catch let jsonErr {
                    print("Failed to decode json:", jsonErr)
                    completion(nil, jsonErr, statusCode)
                }
            }.resume()
        }
        else
        {
            let errorTemp = NSError(domain:"Invalid request", code:400, userInfo:nil)
            completion(nil, errorTemp, 0)
            print("Failed to fetch data:" )
            return
        }
    }
    
    public class func removeAllcookies()
    {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        
    }
    
    private class func createRequest(requesType:String?,url: URL?,param:[String:Any]?,additionalHeader:[String: String]?)->URLRequest?
    {
        guard let urlPath = url else {
            return nil
        }
        
        let param = param
        var request = URLRequest(url: urlPath)
        if(requesType == kPost || requesType == kPut || requesType == kGet )
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = requesType
            if (param != nil)
            {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: param!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        else
        {
            if(param != nil)
            {
                let query = param?.percentEscaped() ?? ""
                request = URLRequest(url: URL(string: (urlPath.absoluteString) +  query)!)
            }
        }
        additionalHeader?.forEach({ (key,value) in
            request.setValue(value, forHTTPHeaderField: key)
        })
        
        return request
        
    }
    
    public class func returnCookie(url:URL?)->HTTPCookie?
    {
        var cookie:HTTPCookie?
        if((url?.absoluteString.contains(""))! || (url?.absoluteString.contains(""))!)
        {
            cookie =  getCookie(url: url, cookiename: kSource)
            if(cookie != nil)
            {
                removeCookies(url: url, cookiename: kSource)
            }
        }
        return cookie
        
    }
    
    public class func getCookie(url:URL?,cookiename:String) -> HTTPCookie?{
        var cookie:HTTPCookie?
        let cookieJar = HTTPCookieStorage.shared
        if(url != nil)
        {
            cookieJar.cookies(for: url!)?.forEach({ (cookies) in
                if(cookies.name == cookiename)
                {
                    cookie = cookies
                }
            })
        }
        return cookie
    }
    
    public class func removeCookies(url:URL?,cookiename:String){
        let cookieJar = HTTPCookieStorage.shared
        if(url != nil)
        {
            cookieJar.cookies(for: url!)?.forEach({ (cookie) in
                if(cookie.name == cookiename)
                {
                    cookieJar.deleteCookie(cookie)
                    return
                }
            })
        }
    }
    
    public class func setPassedCookieSource(cookie:HTTPCookie)
    {
        HTTPCookieStorage.shared.setCookie(cookie)
    }
    
    public class func cancelRequests() {
        URLSession.shared.getAllTasks { dataTasks in
            for task in dataTasks {
                task.cancel()
            }
        }
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
 

