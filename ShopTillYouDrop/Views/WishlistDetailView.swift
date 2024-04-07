//
//  WishlistDetailView.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-04-07.
//

import Foundation

import SwiftUI
import Amplify
import Foundation

struct WishlistDetailView: View {
    
    @State var wishlistItems: ProductDataState
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImageIndex: Int = 0
    @State private var isAutomaticAnimationEnabled = true
    @State private var isHeartFilled = false
    //@State private var offers: [OffersProductData] = []
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: wishlistItems.product_photos![selectedImageIndex]!)) { image in
                    image.image?.resizable().scaledToFit()
                        .frame(width: 400, height: 400)
                }
                .frame(maxHeight: 350)
                .animation(isAutomaticAnimationEnabled ? .easeInOut(duration: 0.5) : nil) // Add conditional animation here
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(wishlistItems.product_photos!.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation {
                                    isAutomaticAnimationEnabled = false
                                    selectedImageIndex = index
                                }
                            }) {
                                AsyncImage(url: URL(string: wishlistItems.product_photos![index]!)) { image in
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
                        
                        Text(wishlistItems.product_title!)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 4)
                        
                        
                        
                    }
                    
                    HStack {
                        
                        Text(wishlistItems.offer?.price ?? "N/A")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding(.trailing)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 9, height: 9)
                        
                        Text("\(String(format: "%.2f", wishlistItems.product_rating ?? 0.0))")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                    }
                    HStack {
                        
                        Text("SOLD BY:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            if let url = URL(string: (wishlistItems.offer?.offer_page_url!)!) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(wishlistItems.offer?.store_name ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Divider()
                    
                    Text("Description")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(wishlistItems.product_description ?? "N/A")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    
                    Text("Compare Price")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    //                    ScrollView(.horizontal) {
                    //                        HStack(spacing: 20) {
                    //                            ForEach(offers, id: \.offer_page_url) { offer in
                    //                                Button(action: {
                    //                                    if let url = URL(string: offer.offer_page_url) {
                    //                                        UIApplication.shared.open(url)
                    //                                    }
                    //                                }) {
                    //
                    //                                    Text("\(offer.store_name)\n \(offer.price)")
                    //                                        .padding()
                    //                                        .background(Color.blue)
                    //                                        .foregroundColor(.white)
                    //                                        .cornerRadius(10)
                    //                                }
                    //                            }
                    //                        }
                    //                        .padding()
                    //                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in
            guard isAutomaticAnimationEnabled else { return }
            let newIndex = (selectedImageIndex + 1) % wishlistItems.product_photos!.count
            withAnimation {
                selectedImageIndex = newIndex
            }
        }
        //.onAppear(perform: fetchOfferData)
    }
}
