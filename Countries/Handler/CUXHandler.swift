//
//  CUXHandler.swift
//  Countries
//
//  Created by Rajaram Mohanty on 30/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation
import UIKit


class CUXHandler {
    
    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    func alert(_ message: String) {
        self.alert(message, completion: nil)
    }
    
    func alert(_ message: String, title: String = "", completion: FuncHouse.voidAction?) {
        DispatchQueue.main.async {
            var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
            topWindow?.rootViewController = UIViewController()
            topWindow?.windowLevel = UIWindow.Level.alert + 1
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                topWindow?.isHidden = true
                topWindow = nil
                
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError("UIAlertController has not been implemented")
                }}))
            topWindow?.makeKeyAndVisible()
            topWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

