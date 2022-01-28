//
//  BaseOperation.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation

@objc private enum OperationState: Int
{
    case ready
    case executing
    case finished
}

public class BaseOperation: Operation
{
    private let configuration = URLSessionConfiguration.default
    var task: URLSessionTask?
    var sessionRequest: URLRequest?
    var urlSession:URLSession?
    var completion: ((Data?, URLResponse?, ResponseStatus) -> Void)?
    
    override init()
    {
        super.init()
        configuration.urlCache = nil
        configuration.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = NetworkConfig.requestTimeoutTime
        urlSession = URLSession(configuration: configuration)
    }
    
    private let stateQueue = DispatchQueue(label: "com.krontiris.operation.state", attributes: .concurrent)
    
    private var rawState = OperationState.ready
    
    @objc private dynamic var state: OperationState
    {
        get
        {
            return stateQueue.sync(execute: { rawState })
        }
        set
        {
            willChangeValue(forKey: "state")
            stateQueue.sync(
                flags: .barrier,
                execute: { rawState = newValue })
            didChangeValue(forKey: "state")
        }
    }
    
    public final override var isReady: Bool
    {
        return state == .ready && super.isReady
    }
    
    public final override var isExecuting: Bool
    {
        return state == .executing
    }
    
    public final override var isFinished: Bool
    {
        return state == .finished
    }
    
    public final override var isAsynchronous: Bool
    {
        return true
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String>
    {
        return ["state"]
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String>
    {
        return ["state"]
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String>
    {
        return ["state"]
    }
    
    public override final func start()
    {
        if isCancelled {
            finish()
            return
        }
        
        state = .executing
        
        execute()
    }
    
    public func execute()
    {
        fatalError("Subclasses must implement this to perform background work and must not call this method with super")
    }
    
    /// Call this function after any work is done or after a call to `cancel()` to move the operation into a completed state.
    public final func finish()
    {
        task?.cancel()
        state = .finished
    }
    
    public final override func cancel()
    {
        finish()
        super.cancel()
    }
}



