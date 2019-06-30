//
//  ErrorHandler.swift
//  Countries
//
//  Created by Rajaram Mohanty on 30/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

enum CError: Error {
    
    case network(Error)
    
    func cook() {
        switch self {
        case .network(let error):
            let message = CError.getNetworkErrorMessage(error)
            CFacade.ux.alert(message, title: "Guidance", completion: nil)
        }
    }
    
    static func getNetworkErrorMessage(_ error: Error) -> String {
        var message = error.localizedDescription
        if NSURLErrorTimedOut == error._code {
            CFacade.ux.alert("Failed to fetch content.")
        } else  if [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet].contains(error._code) {
            message = """
            No network available.
            Check your network status.
            """
        } else if [NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost, NSURLErrorDNSLookupFailed].contains(error._code) {
            message = "System is being checked. \nPlease try again later."
        }
        return message
    }
    
    static func compoundError(_ error: CError) {
        error.cook()
    }
}
