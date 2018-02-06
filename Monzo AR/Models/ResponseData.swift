//
//  ResponseData.swift
//  Monzo AR
//
//  Created by Wayne Rumble on 06/02/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    var transactions: [Transaction]
}

struct Transaction: Decodable {
    var amount: Double
    var description: String
    var notes: String
    var category: String
}
