//
//  Services.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import SNHttpRequest

struct Services {
    
    
   static let shared = Services()
    
    //MARK:- Get Company Config
    typealias CompanyConfigCompletion = (Result<CompanyConfig?>) -> ()
    
    /// Get Company Configuration data
    /// - Parameters:
    ///   - companyUid: Pass Company Uid
    ///   - completion: CompanyConfigCompletion
    func getCompanyConfig(companyUid:String,completion: @escaping CompanyConfigCompletion)
    {
        let urlValue = endpoint + ApiPath.companyConfig + companyUid
        
        
        RequestService.getRequest(url: urlValue) { (response) in
            switch response {
                
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json)
                {
                    let loginResponse = try! JSONDecoder().decode(CompanyConfig.self, from: jsonData)
                    completion(.Success(loginResponse))
                }
                    
                else
                {
                    completion(.Error(.jsonParsingFailure))
                }
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
        
    }
    
    func generateOTP(postData: [String:Any],completion: @escaping ResponseDict)
    {
        let urlValue = endpoint + ApiPath.login
        
        RequestService.postRequest(url: urlValue, postData: postData, method: .post) { (response) in
            switch response {
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                completion(.Success(json))
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
    }
    
    typealias LoginDetailsCompletion = (Result<LoginDetails?>) -> ()
    
    func verifyOTP(postData: [String:Any],completion: @escaping LoginDetailsCompletion)
    {
        let urlValue = endpoint + ApiPath.verifyOTP
        
        
        RequestService.postRequest(url: urlValue, postData: postData, method: MethodType.post) { (response) in
            switch response {
                
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json)
                {
                    let loginResponse = try! JSONDecoder().decode(LoginDetails.self, from: jsonData)
                    completion(.Success(loginResponse))
                }
                    
                else
                {
                    completion(.Error(.jsonParsingFailure))
                }
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
    }
    
    typealias ChecklistDataCompletion = (Result<ChecklistData?>) -> ()
    
    func getChecklists(completion: @escaping ChecklistDataCompletion)
    {
        let urlValue = endpoint + ApiPath.checklists
        
        RequestService.getRequest(url: urlValue, token: getAccesToken() , authType: .bearerToken) { (response) in
            switch response {
                
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json)
                {
                    let checklistResponse = try! JSONDecoder().decode(ChecklistData.self, from: jsonData)
                    completion(.Success(checklistResponse))
                }
                else
                {
                    completion(.Error(.jsonParsingFailure))
                }
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
        
    }
    
    /// Get Checklist Detail
    func getChecklistDetail(checklistUid: String, completion: @escaping ChecklistDataCompletion)
    {
        let urlValue = endpoint + ApiPath.checklists + ApiPath.filterChecklist + checklistUid
        
        RequestService.getRequest(url: urlValue, token: getAccesToken() , authType: .bearerToken) { (response) in
            switch response {
                
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json)
                {
                    let checklistResponse = try! JSONDecoder().decode(ChecklistData.self, from: jsonData)
                    completion(.Success(checklistResponse))
                }
                else
                {
                    completion(.Error(.jsonParsingFailure))
                }
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
        
    }
    /// Submit Checklist
    func submitChecklist(url:String,postData: [String:Any],completion: @escaping ResponseDict)
    {
  
        RequestService.postRequest(url: url, token: getAccesToken(), authType: .bearerToken, postData: postData, method: .post, encoding: .none) { (response) in
            switch response {
            case .ApiError(let apiError):
                completion(.ApiError(apiError))
            case .Success(let json):
                //6 parsing the Json response
                completion(.Success(json))
            case .Error(_):
                completion(.Error(.jsonConversionFailure))
                return
            }
        }
    }
    
    /// Image Upload
    public typealias JSON = (Results<[String:Any]?>) -> ()
    public typealias JSONTaskCompletionHandler = (Results<JSON>) -> ()
    
    //MARK:- Upload Image
    func uploadImage(url:URL,imageData:Data,accesToken: String?,postData:[String:Any]?,method:String,fileName:String,type:String, completionHandler completion: @escaping JSONTaskCompletionHandler)  {
        
        var request = URLRequest(url: url)
        if let token = accesToken
        {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpMethod = method
        
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = NSMutableData()
        let fname = fileName
        let mimetype = type
        //define the data post parameter
        
        if postData != nil
        {
            for (key, value) in postData! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("attachment\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        
        let session = URLSession(configuration: .default)
        var task = URLSessionDataTask()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async(execute: {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.Error(.requestFailed))
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    DispatchQueue.main.async {
                                        completion(.Success(json))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else if httpResponse.statusCode == 400 || httpResponse.statusCode == 401 || httpResponse.statusCode == 404
                    {
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json as! [String : String]))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                    }
                    else if (httpResponse.statusCode == NSURLErrorCancelled || httpResponse.statusCode == NSURLErrorTimedOut || httpResponse.statusCode == NSURLErrorCannotConnectToHost || httpResponse.statusCode == NSURLErrorNetworkConnectionLost || httpResponse.statusCode == NSURLErrorNotConnectedToInternet || httpResponse.statusCode == NSURLErrorInternationalRoamingOff || httpResponse.statusCode == NSURLErrorCallIsActive || httpResponse.statusCode == NSURLErrorDataNotAllowed)
                    {
                        completion(.Error(.offline))
                    }
                    else {
                        
                        
                        if let data = data {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                    DispatchQueue.main.async {
                                        completion(.ApiError(json))
                                    }
                                }
                            } catch {
                                completion(.Error(.jsonConversionFailure))
                            }
                        } else {
                            completion(.Error(.invalidData))
                        }
                      //  completion(.Error(.responseUnsuccessful))
                        print("\(String(describing: error))")
                    }
                })
            }
            task.resume()
        }
    }
}


/// Commom Result for API Response
enum Result <T>{
    case Success(T)
    case Error(ResponseError)
    case ApiError([String:Any])
}

typealias ResponseDict = (Result<[String: Any]>) -> ()

/// ApiResponse Error
enum ResponseError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
    case offline
    
}

/// Zuper environment types
public enum ZuperEnvironments : String {
    case live = ""
    case staging = "https://staging.zuperpro.com/api"
    case local = "http://167.71.224.211:4000"
}


/// Api Path
 struct ApiPath {
    static var companyConfig = "/company/config?company_uid="
    static var login = "/login"
    static var verifyOTP = "/verify/otp"
    static var checklists = "/company/checklist"
    static var imageUpload = "/upload?attachment_type="
    static var submitChecklist = "/user/checklist"
    static var filterChecklist = "?filter.checklist_uid="
}
