//
//  ProductView.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import SwiftUI

struct ProductView: View {
    
    var input: String
    
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationView {
                   List(products) { product in
                       Text(product.title)
                   }
                   .navigationTitle("Products")
               }
        .onAppear(perform: fetchData)
    }
    
    
    func fetchData() {
            let headers = [
                "X-RapidAPI-Key": "f78ec949c9msh56530a588aa61f8p1a1246jsn843e6d48ab6f",
                "X-RapidAPI-Host": "pricer.p.rapidapi.com"
            ]

            let request = NSMutableURLRequest(url: NSURL(string: "https://pricer.p.rapidapi.com/str?q=\(input)")! as URL,
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
                            let decodedData = try JSONDecoder().decode([Product].self, from: data)
                            DispatchQueue.main.async {
                                self.products = decodedData
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
    

