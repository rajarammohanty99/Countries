//
//  CountriesModel.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

struct Currency:Codable {
    let c_name: String?
    
    private enum CodingKeys: String, CodingKey {
        case c_name = "name"
    }
}

struct Language:Codable {
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

struct CountriesModel: Codable {
    let flag: String?
    let capital: String?
    let country: String?
    let callingcode: [String]?
    let region: String?
    let sub_region: String?
    let time_zone: [String]?
    let currencies: [Currency?]
    let languages: [Language?]
    
    
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
            return URL(string: flag ?? "trst")!
        }
    }
}

