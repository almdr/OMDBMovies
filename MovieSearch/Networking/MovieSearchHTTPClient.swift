//
//  MovieSearchHTTPClient.swift
//
//
//  Created by Alfonso  on 18/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

struct MovieSearchHTTPClient: HTTPClient {

    let session: URLSession
    let tokenAuthorizator: Authorization

    init(authorization: Authorization = TokenAuthorization(), session: URLSession = URLSession.shared) {
        self.tokenAuthorizator = authorization
        self.session = session
    }
    
    var authorizator: Authorization {
        tokenAuthorizator
    }
}
