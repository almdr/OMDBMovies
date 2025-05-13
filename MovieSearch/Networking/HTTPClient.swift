//
//  HTTPClient.swift
//  
//
//  Created by Alfonso  on 12/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
    func sendRequest<T>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
    var authorizator: Authorization { get }
    var session: URLSession { get }
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            throw RequestError.invalidURL
        }
        print("url \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if endpoint.authorize {
            request.addValue(await "Bearer \(authorizator.getToken())",
                             forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        do {
            let (data, response) = try await session.data(for: request, delegate: nil)
            
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    throw RequestError.decode
                }
                return decodedResponse
                
            case 401:
                throw RequestError.unauthorized
            default:
                throw RequestError.unexpectedStatusCode
            }
        } catch (let error) {
            throw RequestError.unknown
        }
    }
    
    func sendRequest<T>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        print("urlComponents.url \(urlComponents.url)")
        guard let url = urlComponents.url else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if endpoint.authorize {
            request.addValue(await "Bearer \(authorizator.getToken())",
                             forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body {
            request.httpBody = body
        }
    
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? T else {
                throw RequestError.decode
            }
            return json
        case 401:
            throw RequestError.unauthorized
        default:
            throw RequestError.unexpectedStatusCode
        }
    }
}
