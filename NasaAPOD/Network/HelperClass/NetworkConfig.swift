//
//  NetworkConfig.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import Foundation

class NetworkConfig
{
    enum AppMode: Int
    {
        case network
        case mock
    }
    
    static let maxOperationCount = 10
    static let minOperationCount = 1
    static let requestTimeoutTime: TimeInterval = 30.0
    
    private static var appMode: AppMode = .network
    
    static func setAppMode(mode: AppMode)
    {
        appMode = mode
    }
    
    static func getAppMode() -> AppMode
    {
        return appMode
    }
}
