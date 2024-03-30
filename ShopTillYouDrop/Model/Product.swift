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

struct ProductData: Codable {
    let product_id: String
    let product_title: String
    let product_photos: [String]
    let product_rating: Double?
    let product_description: String!
    let offer: Offer
}

struct Offer: Codable {
    let store_name: String
    let price: String
    let offer_page_url: String!
}


