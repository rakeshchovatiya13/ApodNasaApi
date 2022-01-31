//
//  EndPoints.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import Foundation

let BASE_URL   = "https://api.nasa.gov"
let API_KEY    = "wiKyWcIW5s6YI7vrFWGsqk381UoDQpcq7oCUyoJc"

enum Apod_API: String
{
    case apod = "/planetary/apod"
}

enum HttpMethod: String
{
    case GET
    case POST
    case PUT
    case DELETE
    case NONE
}

class EndPoints
{
    private init() {
    }
    
    static func getRequestURL(api : Apod_API, count: Int) -> URL?
    {
        return RequestBuilder().encodeQueryParameter(parameters: ["api_key" : API_KEY, "count" : count, "thumbs" : true],
                                                     url: BASE_URL + api.rawValue)
    }
    
    static func getHTTPMode(api: Apod_API) -> String?
    {
        switch api
        {
        case .apod:
            return HttpMethod.GET.rawValue
        }
    }
}
