//
//  NetworkOperationQueue.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation

class NetworkOperationQueue: OperationQueue
{
    override init()
    {
        super.init()
        maxConcurrentOperationCount = NetworkConfig.maxOperationCount
    }
}
