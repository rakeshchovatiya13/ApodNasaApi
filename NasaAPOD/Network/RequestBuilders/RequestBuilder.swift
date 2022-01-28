//
//  RequestBuilder.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation

internal class RequestBuilder
{
    internal func encodeParameter<T>(parameters: [String: Any]?) -> T?
    {
        guard let parameters = parameters else {
            return nil
        }
        var parametersString = ""
        var delimiter = ""
        for (key, value) in parameters {
            parametersString.append("\(delimiter)\(key)=\(value)")
            delimiter = "&"
        }
        
        if Data.self == T.self {
            return parametersString.data(using: String.Encoding.utf8) as? T
        } else if String.self == T.self {
            return parametersString as? T
        }

        return nil
    }
    
    internal func encodeQueryParameter(parameters: [String: Any]?, url : String?) -> URL?
    {
        guard let parameters = parameters , let url = url else {
            return nil
        }
        
        if var parametersString: String = encodeParameter(parameters: parameters) {
            parametersString = "?" + parametersString
            return URL(string: url + parametersString)
        }
        return nil
    }
}

extension RequestBuilder
{
    func getRequestObject(api: Apod_API, count: Int = 0) throws -> URLRequest?
    {
        guard let requestURL = EndPoints.getRequestURL(api: api, count: count) else {
            print("Unable to get request URL")
            return nil
        }
        var requestObj = URLRequest(url: requestURL)
        requestObj.httpMethod = EndPoints.getHTTPMode(api: api)
        return requestObj
    }
}
