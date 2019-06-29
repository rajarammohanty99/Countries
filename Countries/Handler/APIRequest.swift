//
//  APIRequest.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: String { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard let components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url.appendingPathComponent(parameters))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

