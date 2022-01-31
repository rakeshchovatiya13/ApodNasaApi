//
//  ResponseStatus.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation

public enum InAppErrorCodes: Int
{
    case unhandledException = -9176344
    case sessionExpired     = -9176345
    case invalildRequest    = -9176346
    case noNetworkConnection = -9176347
    case connectionTimeout = -9176348
    case cancelled = -9176349
    case noServerConnection = -9176350
    case networkConnectionLost = -9176351
}

enum HttpStatusCode: Int
{
    case CODE_200   = 200 // Success
    case CODE_400   = 400 // Bad request
    case CODE_401   = 401 // Unauthorized
    case CODE_403   = 403 // Forbidden
    case CODE_404   = 404 // Not found
    case CODE_500   = 500 // Internal server error
}

public struct ResponseData: Codable
{
    let data: String?
}

public class ResponseStatus
{
    public internal(set) var errorMessage: String = ""
    public internal(set) var errorCode: Int = 0
    public internal(set) var statusCode: Int = 0
    public internal(set) var error: Error?

    public var isSuccess: Bool
    {
        return statusCode == HttpStatusCode.CODE_200.rawValue && errorCode == 0
    }
    
    init() {
    }
    
    init(data: Data?, response: URLResponse?, error: Error?)
    {
        self.error = error
        if let response = response
        {
            if let httpResponse = response as? HTTPURLResponse
            {
                self.statusCode = httpResponse.statusCode
            }
        }

        if let error = error
        {
            self.errorMessage = error.localizedDescription
            self.errorCode = InAppErrorCodes.sessionExpired.rawValue
        }
        else if let data = data
        {
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                self.errorMessage = responseData.data ?? ""
            }
            catch {
                self.errorMessage = ""
            }
        }
        
        if self.errorMessage.contains("The request timed out.")
        {
            self.errorCode = InAppErrorCodes.connectionTimeout.rawValue
        }
        
        if self.errorMessage.contains("cancelled")
        {
            self.errorCode = InAppErrorCodes.cancelled.rawValue
        }
        
        if self.errorMessage.contains("The Internet connection appears to be offline.")
        {
            self.errorCode = InAppErrorCodes.noNetworkConnection.rawValue
        }
        
        if self.errorMessage.contains("expired timestamp")
        {
            self.errorCode = InAppErrorCodes.sessionExpired.rawValue
        }
        
        if self.errorMessage.contains("Could not connect to the server")
        {
            self.errorCode = InAppErrorCodes.noServerConnection.rawValue
        }

        if self.errorMessage.contains("The network connection was lost")
        {
            self.errorCode = InAppErrorCodes.networkConnectionLost.rawValue
        }
    }
    
    init(errorMessage: String, errorCode: Int, httpStatusCode: Int)
    {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
        self.statusCode = httpStatusCode
    }
}
