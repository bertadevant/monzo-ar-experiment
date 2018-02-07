//
//  DataFactory.swift
//  Monzo AR
//
//  Created by Wayne Rumble on 06/02/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

class DataFactory {
    
    func parseJSON(fileName: String) -> ResponseData? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
