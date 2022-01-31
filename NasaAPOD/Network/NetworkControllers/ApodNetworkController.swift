//
//  ApodNetworkController.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 28/01/22.
//

import Foundation
import ProgressHUD

class ApodNetworkController: BaseNetworkController
{
    override init() {
        super.init()
    }
    
    func getApodList(count: Int = 1, completion: (([ApodInfoBean]?, ResponseStatus) -> Void)?) -> BaseOperation?
    {
        do {
            // Show HUD
            ProgressHUD.show(interaction: false)
            // Build Request Object
            guard let requestObj = try RequestBuilder().getRequestObject(api: .apod, count: count) else {
                let errorMsg = "Unable to build request object."
                print(errorMsg)
                completion?(nil, ResponseStatus(errorMessage: errorMsg, errorCode: InAppErrorCodes.invalildRequest.rawValue, httpStatusCode: 0))
                return nil
            }
            
            return addOperation(request: requestObj, jsonPath: .apod) { (data, _, responseStatus) in
                
                var apodData: [ApodInfoBean]?
                if responseStatus.isSuccess, let data = data
                {
                    apodData = BaseNetworkController.decodeData(data: data)
                    if NetworkConfig.getAppMode() == .network
                    {
                        // Cashe latest apod data on every successful api call
                        if let apodList = apodData, apodList.count > 0
                        {
                            DefaultStore.setObject(value: apodList, key: .apodInfoData)
                        }
                    }
                    // Dismiss HUD
                    ProgressHUD.dismiss()
                }
                else
                {
                    if NetworkConfig.getAppMode() == .network
                    {
                        // Should show last cashed data on api call failure
                        apodData = DefaultStore.getObject(key: .apodInfoData)
                    }
                    
                    // Show internal response error
                    var errorMessage = responseStatus.errorMessage
                    // Handle server side error
                    // errorCode is Zero for servcer side error
                    if responseStatus.errorCode == 0, let errorData = data
                    {
                        let errorResponse: ErrorResponse? = BaseNetworkController.decodeData(data: errorData)
                        errorMessage = errorResponse?.msg ?? "Error"
                    }
                    ProgressHUD.showFailed(errorMessage)
                }

                DispatchQueue.main.async {
                    completion?(apodData, responseStatus)
                }
            }
        } catch let error {
            ProgressHUD.dismiss()
            print(error.localizedDescription)
            completion?(nil, ResponseStatus(errorMessage: error.localizedDescription, errorCode: InAppErrorCodes.unhandledException.rawValue, httpStatusCode: 0))
            return nil
        }
    }
}
