//
//  ApodVCModel.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import Foundation

class ApodVCModel
{
    private var apodList: [ApodInfoBean] = []
    private var filteredApodList: [ApodInfoBean] = []
    
    /// Fetch Apod List from web api and store results into  `apodList`.
    func fetchApodList(completion: (() -> Void)?)
    {
        _ = ApodNetworkController().getApodList(count: 10, completion: { (data, response) in
            if response.isSuccess, let apodData = data, self.apodList != apodData
            {
                self.apodList = apodData
            }
            completion?()
        })
    }
    
    /**
    Filter data from `apodList` and store results into `filteredApodList`
     - Parameters:
        - searchText: text to use compare string in array of object
    */
    func filterApodList(for searchText: String)
    {
        filteredApodList = apodList.filter { (roster: ApodInfoBean) -> Bool in
            return roster.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    /**
    Return array of apod list based on isFiltering boolean parameter.
     - Parameters:
        - isFiltering:
            - True: Return `filteredApodList`
            - false: return `apodList`
    */
    func getApodList(isFiltering: Bool) -> [ApodInfoBean]
    {
        isFiltering ? filteredApodList : apodList
    }
}
