//
//  Authorization.swift
//  
//
//  Created by Alfonso  on 18/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

protocol Authorization {
    func getToken() async -> String
    func removeToken() async
}

