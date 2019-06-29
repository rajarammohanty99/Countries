//
//  CountriesRequest.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

class CountriesRequest: APIRequest {
    var method = RequestType.GET
    var path = "rest/v2/name"
    var parameters = String()
    
    
    init(name: String) {
        parameters = name
    }
}

