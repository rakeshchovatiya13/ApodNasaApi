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
    
    func getApodList(count: Int = 50, completion: (([ApodInfoBean]?, ResponseStatus) -> Void)?) -> BaseOperation?
    {
        do {
            ProgressHUD.show(interaction: false)
            
            guard let requestObj = try RequestBuilder().getRequestObject(api: .apod, count: count) else {
                let errorMsg = "Unable to build request object."
                print(errorMsg)
                completion?(nil, ResponseStatus(errorMessage: errorMsg, errorCode: InAppErrorCodes.invalildRequest.rawValue, httpStatusCode: 0))
                return nil
            }
            
            return addOperation(request: requestObj, jsonPath: .apod) { (data, _, responseStatus) in
                
                var apodList: [ApodInfoBean]?
                if let data = data
                {
                    apodList = BaseNetworkController.decodeData(data: data)
                }
                
                if !responseStatus.isSuccess
                {
                    ProgressHUD.showFailed(responseStatus.errorMessage)
                }
                else
                {
                    ProgressHUD.dismiss()
                }

                DispatchQueue.main.async {
                    completion?(apodList, responseStatus)
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
