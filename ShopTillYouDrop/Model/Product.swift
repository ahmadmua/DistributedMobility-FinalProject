//
//  Price.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import Foundation

struct ProductResponse: Codable {
    let data: [ProductData]
}

struct ProductData: Codable, Identifiable {
    let id = UUID()
    let product_title: String
    let product_photos: [String]
    let offer: Offer
}

struct Offer: Codable {
    let store_name: String
    let price: String
}


