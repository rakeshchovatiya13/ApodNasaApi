//
//  NetworkOperation.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation
import UIKit

extension URLSession
{
    func synchronousDataTask(with request: URLRequest) -> (Data?, URLResponse?, Error?)
    {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: request)
        {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        return (data, response, error)
    }
}

class NetworkOperation : BaseOperation
{
    var jsonFilepath: JsonFileManager.JSONFile = .none
    
    let responseStatus = ResponseStatus()
    
    override init()
    {
        super.init()
        //Added below to listen to .UIApplicationDidEnterBackground Notification to cancel any ongoing url session task since app going to background.
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit
    {
        print("Operation Class Deinitialized: " + self.debugDescription)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appMovedToBackground()
    {
        print("App goes background so cancel the ongoing url session tasks")
        //invalidate the session by cancelling all tasks
        urlSession?.invalidateAndCancel()
    }
    
    override func execute()
    {
        guard let sessionRequest = sessionRequest else { return }
        
        if NetworkConfig.getAppMode() == .mock
        {
            //this will return data from mock json file
            makeMockResponse(request: sessionRequest, jsonPath: jsonFilepath)
            finish()
        }
        else
        {
            guard (sessionRequest.url?.absoluteString) != nil else {
                responseStatus.errorMessage = "Invalid Request URL."
                responseStatus.errorCode = InAppErrorCodes.invalildRequest.rawValue
                self.completion?(nil, nil, responseStatus)
                finish()
                return
            }
            sendRequest(sessionRequest: sessionRequest)
        }
    }
        
    private func sendRequest(sessionRequest: URLRequest)
    {
        task = urlSession?.dataTask(with: sessionRequest, completionHandler: {(data, response, error) in
            if let jsonData = data
            {
                self.completion?(jsonData, response, ResponseStatus(data: jsonData, response: response, error: error))
            }
            else
            {
                self.completion?(nil, response, ResponseStatus(data: nil, response: response, error: error))
            }
            self.finish()
        })
        task?.resume()
    }
    
    private func makeMockResponse(request: URLRequest, jsonPath: JsonFileManager.JSONFile)
    {
        if let url = request.url
        {
            guard let mockResponse = HTTPURLResponse(url: url, statusCode: HttpStatusCode.CODE_200.rawValue, httpVersion: nil, headerFields: nil) else {
                print("Unable to get Mock response.")
                return
            }
            
            guard let jsonDict = JsonFileManager.getFileData(filePath: jsonPath) else {
                print("Bad Mock JSON.")
                return
            }
            completion?(jsonDict, mockResponse, ResponseStatus(data: jsonDict, response: mockResponse, error: nil))
            print("******************************** This is Mock Response ************************************")
            return
        }
        print("Invalid mock response.")
        return
    }
    
}


