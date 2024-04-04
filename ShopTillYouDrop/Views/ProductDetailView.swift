//
//  ProductInfo.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-29.
//

import SwiftUI
import Amplify
import Foundation

struct ProductDetailView: View {
    
    var product: ProductDataState
    
    @State private var selectedImageIndex: Int = 0
    @State private var isAutomaticAnimationEnabled = true
    @State private var isHeartFilled = false
    @StateObject var amplifyController = AmplifyDBController()
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: product.product_photos[selectedImageIndex])) { image in
                    image.image?.resizable().scaledToFit()
                        .frame(width: 400, height: 400)
                }
                .frame(maxHeight: 350)
                .animation(isAutomaticAnimationEnabled ? .easeInOut(duration: 0.5) : nil) // Add conditional animation here
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(product.product_photos.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    isAutomaticAnimationEnabled = false
                                    selectedImageIndex = index
                                }
                            }) {
                                AsyncImage(url: URL(string: product.product_photos[index])) { image in
                                    image.image?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                .frame(width: 80, height: 80)
                                .padding(.top, 15)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        
                        Text(product.product_title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 4)
                        
                        Button(action: {
                            isHeartFilled.toggle()
                            Task {
                                //await amplifyController.createProductData()
                            }
                        }) {
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart").resizable()
                                .frame(width: 27, height: 27)
                                .foregroundColor(.red)
                                .padding(.leading, 5)
                        }

                        
                        
                    }
                    
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
                    HStack {
                        
                        Text("SOLD BY:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            if let url = URL(string: product.offer.offer_page_url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(product.offer.store_name)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
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
        .onReceive(timer) { _ in
            guard isAutomaticAnimationEnabled else { return }
            let newIndex = (selectedImageIndex + 1) % product.product_photos.count
            withAnimation {
                selectedImageIndex = newIndex
            }
        }
    }
}






//struct ProductDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let product = ProductData(product_id: "1",
//                                  product_title: "Nike Retro A1",
//                                  product_photos: ["https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/5b0981ff-45f8-40c3-9372-32430a62aaea/dunk-high-shoes-JW4zhB.png"],
//                                  product_rating: 4.5, product_description: "The Nike Dunk Low Retro White Black (PS) sneakers combine iconic style with modern comfort. With its timeless white and black colorway, these sneakers are versatile and perfect for any occasion. The retro design pays homage to the original Nike Dunk, while the low-top silhouette offers a contemporary vibe. Crafted with premium materials, these sneakers provide durability and support. Whether you're hitting the skate park or strolling the streets, the Nike Dunk Low Retro White Black (PS) sneakers will elevate your footwear game",
//                                  offer: Offer(store_name: "Amazon", price: "$19.99", offer_page_url: "TEST URL"))
//        return ProductDetailView(product: product)
//    }
//}
