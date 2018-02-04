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
    private let baseURL = "https://auth.monzo.com/"
    private let redirectURI = "https://Monzo-AR.novoda.com"
    private let responseType = "code"
    private let stateToken = "random string"
    private var requestURL: String!
    
    init() {
        requestURL = baseURL +
            "?client_id=" +
            clientID +
            "&redirect_uri=" +
            redirectURI +
            "&response_type=" +
            responseType +
            "&state=" +
        stateToken
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
