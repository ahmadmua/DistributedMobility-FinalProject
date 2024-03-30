//
//  ProductInfo.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-29.
//

import SwiftUI

struct ProductDetailView: View {
    
    var product: ProductData
    
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: product.product_photos[selectedImageIndex])) { image in
                    image.image?.resizable().scaledToFit()
                }
                .frame(maxHeight: 300)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(product.product_photos.indices, id: \.self) { index in
                            Button(action: {
                                selectedImageIndex = index
                            }) {
                                AsyncImage(url: URL(string: product.product_photos[index])) { image in
                                    image.image?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                .frame(width: 80, height: 80)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(product.product_title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 4)
                    
                    HStack {
                        
                        Text(product.offer.price)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding(.trailing)
                     
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 9, height: 9)
                        
                        Text("\(String(format: "%.2f", product.product_rating ?? 0.0))")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                    }
                    
                    
                    Text(product.offer.store_name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(product.product_description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}





struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = ProductData(product_id: "1",
                                   product_title: "Nike Retro A1",
                                   product_photos: ["https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/5b0981ff-45f8-40c3-9372-32430a62aaea/dunk-high-shoes-JW4zhB.png"],
                                  product_rating: 4.5, product_description: "The Nike Dunk Low Retro White Black (PS) sneakers combine iconic style with modern comfort. With its timeless white and black colorway, these sneakers are versatile and perfect for any occasion. The retro design pays homage to the original Nike Dunk, while the low-top silhouette offers a contemporary vibe. Crafted with premium materials, these sneakers provide durability and support. Whether you're hitting the skate park or strolling the streets, the Nike Dunk Low Retro White Black (PS) sneakers will elevate your footwear game",
                                  offer: Offer(store_name: "Amazon", price: "$19.99"))
        return ProductDetailView(product: product)
    }
}
