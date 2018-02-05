//
//  APIClient.swift
//  Monzo AR
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    private let clientID = "oauthclient_00009THxqI5SMFK6JudM9J"
    private let baseURL = "https://auth.getmondo.co.uk/?"
    private let redirectURI = "https://www.novoda.com"
    private let responseType = "code"
    private let stateToken = "random string"
    private var requestURL: String!
    
    init() {
        requestURL = "https://auth.monzo.com/?client_id=oauthclient_00009THxqI5SMFK6JudM9J&redirect_uri=https://www.novoda.com&response_type=code&state=state"
    }
    
    func request() {
        Alamofire.request(baseURL).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
