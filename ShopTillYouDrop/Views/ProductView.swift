//
//  ProductView.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import SwiftUI
import AWSS3StoragePlugin
import Amplify

struct ProductView: View {
    
    var input: String
    @State private var products: [Product] = []
    
    let api = APIController()
    
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
                                image.resizable().scaledToFit().frame(width: 55, height: 55)
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
                                    
                                    Text("\(product.offer.store_name ?? "NA")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(product.offer.price ?? "N/A")
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
            api.fetchSortedData(input: input, sortOrder: sortOrder) { fetchedProducts in
                self.products = fetchedProducts
            }
        })
        
    }
    
    func fetchData() {
        api.fetchSortedData(input: input, sortOrder: sortOrder) { fetchedProducts in
            self.products = fetchedProducts
        }
    }
    
    
}

//struct Previews_ProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductView(input: "iphone")
//    }
//}
