//
//  JsonFileManager.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import Foundation

class JsonFileManager
{
    // Mock JSON Files
    public enum JSONFile : String
    {
        case apod = "Apod_Response"
        case none
    }
    
    // MARK: - Static Methods
    
    public static func getFileData(filePath: JSONFile, fileExtension: String = "json") -> Data?
    {
        if let bundlePath = Bundle.main.url(forResource: filePath.rawValue, withExtension: fileExtension)
        {
            do
            {
                let data = try Data(contentsOf: bundlePath, options: .alwaysMapped)
                return data
            }
            catch let error
            {
                print(error.localizedDescription)
            }
        }
        else
        {
            print("Invalid filename/path.")
        }
        return nil
    }
}
