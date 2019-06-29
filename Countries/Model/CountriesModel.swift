//
//  CountriesModel.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

struct Currency:Codable {
    let code: String?
    let c_name: String?
    let symbol: String?
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case c_name = "name"
        case symbol = "symbol"
    }
}

struct Language:Codable {
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

struct CountriesModel: Codable {
    private let flag: String
    let capital: String?
    let country: String?
    let callingcode: [String]
    let region: String?
    let sub_region: String?
    let time_zone: [String]
    let currencies: [Currency]
    let languages: [Language]
    
    
    private enum CodingKeys: String, CodingKey {
        case flag = "flag"
        case capital = "capital"
        case country = "name"
        case callingcode = "callingCodes"
        case region = "region"
        case sub_region = "subregion"
        case time_zone = "timezones"
        case currencies = "currencies"
        case languages = "languages"
    }
    
    var flagUrl:URL{
        get{
            return URL(string: flag) ?? URL(fileURLWithPath: "trst")
        }
    }
}

