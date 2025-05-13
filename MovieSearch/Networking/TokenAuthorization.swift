//
//  TokenAuthorization.swift
//
//
//  Created by Alfonso  on 18/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

actor TokenAuthorization: Authorization {
    
    func getToken() async -> String {
        let dicUserData = KeyChainAccess.loadSecurityData()
        if let data = dicUserData["data"] as? [String: Any],
           let jwtToken = data["jwtToken"] as? String {
            return jwtToken
        }
        return ""
    }
    
    func removeToken() async {
        KeyChainAccess.removeSecurityData()
    }
}
