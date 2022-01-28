//
//  BaseNetworkController.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation

public class BaseNetworkController
{
    /// This operationQueue will have one instance all the time. hence declared as static
    private static let operationQueue = NetworkOperationQueue()
    
    init() {
    }
    
    func addOperation(request: URLRequest, jsonPath: JsonFileManager.JSONFile, completion: @escaping (Data?, URLResponse?, ResponseStatus) -> Void) -> BaseOperation
    {
        let operation = NetworkOperation()
        operation.jsonFilepath = jsonPath
        operation.sessionRequest = request
        operation.completion = completion
        BaseNetworkController.operationQueue.addOperation(operation)
        return operation
    }
    
    static func setMinimumConcurrentOperationCount()
    {
        setConncurrentOperationCount(count: NetworkConfig.minOperationCount)
    }
    
    static func setDefaultConcurrentOperationCount()
    {
        setConncurrentOperationCount(count: NetworkConfig.maxOperationCount)
    }
    
    private static func setConncurrentOperationCount(count: Int)
    {
        if count != operationQueue.maxConcurrentOperationCount
        {
            operationQueue.maxConcurrentOperationCount = count
        }
    }
}

/// Encode and Decode  data
extension BaseNetworkController
{
    internal static func decodeData<T: Codable>(data: Data) -> T?
    {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }
        catch {
            print("Error : ", error)
        }
        return nil
    }
    
    internal static func encodeData<T: Encodable>(_ value: T) -> Data
    {
        var jsonData = Data()
        do {
            let jsonEncoder = JSONEncoder()
            jsonData = try jsonEncoder.encode(value)
        }
        catch {
            print("Error : ", error)
        }
        return jsonData
    }
}
