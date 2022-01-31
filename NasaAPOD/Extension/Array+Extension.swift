//
//  Array+Extension.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 31/01/22.
//

import Foundation

extension Array
{

    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func item(at index: Int) -> Element?
    {
        if 0 <= index && index < count
        {
            return self[index]
        }
        else
        {
            return nil
        }
    }
}
