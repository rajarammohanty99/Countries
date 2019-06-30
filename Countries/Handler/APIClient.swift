//
//  APIClient.swift
//  Countries
//
//  Created by Rajaram Mohanty on 28/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "https://restcountries.eu")!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    print(request)
                    CError.compoundError(CError.network(error))
                    return
                }

                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch(httpResponse.statusCode)
                        {
                        case 200:
                            let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                            observer.onNext(model)
                        default:
                            print("GET resquest not successful. http status code \(httpResponse.statusCode)")
                            let jsonText:String = "[]"
                            let new_data:Data? = jsonText.data(using: String.Encoding.utf8)
                            let model: T = try JSONDecoder().decode(T.self, from: new_data ?? Data())
                            observer.onNext(model)
                        }
                    }
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func getOfflineData<T: Codable>(searchText: String) -> Observable<T> {
        return Observable<T>.create{ observer in
            do {
                let search_text = searchText
                let jsonText:String = (search_text != "") ? CoreDataRequest.coreDataRequestShareInstant.fetchRequest(value: search_text) : CoreDataRequest.coreDataRequestShareInstant.fechAllCountries()
                let new_data:Data? = jsonText.data(using: String.Encoding.utf8)
                let model: T = try JSONDecoder().decode(T.self, from: new_data ?? Data())
                observer.onNext(model)
            } catch let error {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create {}
        }
    }
}

