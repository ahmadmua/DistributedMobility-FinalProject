//
//  ProductView.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import SwiftUI

struct ProductView: View {
    
    var input: String
    @State private var products: [ProductDataState] = []
    @State private var sortOrder: String = "BEST_MATCH"
    
    var body: some View {
    
            VStack {
                Picker("Sort Order", selection: $sortOrder) {
                    Text("Best Match").tag("BEST_MATCH")
                    Text("Top Rated").tag("TOP_RATED")
                    Text("Lowest Price").tag("LOWEST_PRICE")
                    Text("Highest Price").tag("HIGHEST_PRICE")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(products, id: \.product_id) { product in
                    
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        
                        HStack {
                            AsyncImage(url: URL(string: product.product_photos.first ?? "")) { image in
                                image.resizable().scaledToFit().frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            VStack(alignment: .trailing) {
                                
                                HStack{
                                    
                                    Text(product.product_title)
                                        .font(.headline)
                                    Spacer()
                                    
                                }
                                
                                HStack {
                                    
                                    Text("\(product.offer.store_name)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(product.offer.price)
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    
                                    
                                    
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    
                                        .frame(width: 9, height: 9)
                                    
                                    
                                    Text("\(String(format: "%.2f", product.product_rating ?? "N/A"))")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    
                                    
                                    Spacer()
                                    
                                }
                                
                            }
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .navigationTitle("Products")
                
            }
        
        .onAppear(perform: fetchData)
        .onChange(of: sortOrder, perform: { _ in
            fetchSortedData()
        })
    }
    
    func fetchData() {
        fetchSortedData()
    }
    
    func fetchSortedData() {
        let headers = [
            "X-RapidAPI-Key": "2f97e8506bmsh25356e3490e7c7bp1344f9jsn7720690c277c",
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
                            self.products = decodedData.data
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

