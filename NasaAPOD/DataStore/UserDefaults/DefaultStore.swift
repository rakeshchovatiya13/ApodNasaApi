//
//  DefaultStore.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 31/01/22.
//

import Foundation

public class DefaultStore
{
    //Removed serial queue and sempahore since UserDefaults class is thread safe by default
    
    public enum DefaultStoreKey: String
    {
        case apodInfoData = "apodInfoData"
    }
    
    private init() {
        
    }
    
    // MARK: Setter & Getter for Codable objects
    public static func getObject<T: Codable>(key: DefaultStoreKey) -> T?
    {
        guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
            print("unable to retrieve data")
            return nil
        }
        // Use PropertyListDecoder to convert data into Codable object
        guard let objectData = try? PropertyListDecoder().decode(T.self, from: data) else {
            print("unable to decode data in to codable object")
            return nil
        }
        return objectData
    }
    
    public static func setObject<T: Codable>(value: T, key: DefaultStoreKey)
    {
        do {
            let data = try PropertyListEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        } catch {
            assertionFailure("Save Failed")
        }
    }
    
    // MARK: Setter & Getter for all generic types
    public static func getValue<T>(key: DefaultStoreKey) -> T?
    {
        if let anyValue = UserDefaults.standard.object(forKey: key.rawValue)
        {
            guard let value = anyValue as? T else {
                assertionFailure("Expected " + String(describing: T.self) + ": Unable to cast: " + key.rawValue)
                return nil
            }
            return value
        }
        print("key not found. \(key)")
        return nil
    }
    
    // MARK: Remove objects from UserDefaults
    public static func delete(key: DefaultStoreKey)
    {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
