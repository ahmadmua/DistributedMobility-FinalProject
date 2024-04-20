//
//  APIController.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-04-19.
//

import Foundation


class APIController {
    
    func fetchSortedData(input: String, sortOrder: String, completion: @escaping ([Product]) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "8069de275cmsh4137db7f77804bcp11b40ejsn18ed2012d5b9",
            "X-RapidAPI-Host": "real-time-product-search.p.rapidapi.com"
        ]
        
        guard let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding input")
            return
        }
        
        let urlString = "https://real-time-product-search.p.rapidapi.com/search?q=\(encodedInput)&country=ca&language=en&limit=100&sort_by=\(sortOrder)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ProductResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(decodedData.data)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchOfferData(completion: @escaping ([OffersProductData]) -> Void, product: Product) {
        
        let headers = [
            "X-RapidAPI-Key": "8069de275cmsh4137db7f77804bcp11b40ejsn18ed2012d5b9",
            "X-RapidAPI-Host": "real-time-product-search.p.rapidapi.com"
        ]
        
        let urlString = "https://real-time-product-search.p.rapidapi.com/product-offers?product_id=\(product.product_id)&country=ca&language=en"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(OffersResponse.self, from: data)
                        DispatchQueue.main.async {
                           completion(decodedData.data.offers)
                            //print(self.offers)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }
        }
        
        dataTask.resume()
    }

    
    
}
