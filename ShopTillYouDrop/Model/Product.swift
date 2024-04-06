//
//  Price.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import Foundation
import Amplify


struct ProductResponse: Codable {
    let data: [ProductDataState]
}

struct ProductDataState: Codable {
    let product_id: String
    let product_title: String
    let product_photos: [String]
    let product_rating: Double?
    let product_description: String?
    let offer: OfferState
}

struct OfferState: Codable {
    let store_name: String
    let price: String
    let offer_page_url: String!
}

//------------NEW API MODEL FOR OFFERS---------------------//

struct OffersResponse: Codable {
    let data: OffersDataState
}

struct OffersDataState: Codable {
    let offers: [OffersProductData]
}

struct OffersProductData: Codable{
    let store_name: String
    let price: String
    let offer_page_url: String!
    let product_num_reviews: Int
}


