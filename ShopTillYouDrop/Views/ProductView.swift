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
                
                HStack {
                    AsyncImage(url: URL(string: product.img)) { image in
                        image.resizable().scaledToFit().frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment: .trailing) {
                        
                        HStack{
                            
                            Text(product.title)
                                .font(.headline)
                            Spacer()
                            
                        }
                        
                        HStack {
                            
                            Text("\(product.shop.replacingOccurrences(of: "from", with: "").trimmingCharacters(in: .whitespacesAndNewlines))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(product.price)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                        }
                        
                    }
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
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







struct Previews_ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(input: "iphone")
    }
}
