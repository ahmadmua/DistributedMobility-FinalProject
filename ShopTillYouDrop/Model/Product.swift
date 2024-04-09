//
//  Price.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import Foundation
import Amplify

//Search
struct ProductResponse: Codable {
    let data: [Product]
}
//Search
struct Product: Codable {
    let product_id: String
    let product_title: String
    let product_photos: [String]
    let product_rating: Double?
    let product_description: String?
    let offer: Offer
}
//Search
struct Offer: Codable {
    let store_name: String
    let price: String
    let offer_page_url: String!
}

//------------NEW API MODEL FOR OFFERS---------------------//
//Offers
struct OffersResponse: Codable {
    let data: OffersDataState
}

//Offers
struct OffersDataState: Codable {
    let offers: [OffersProductData]
}
//Offers
struct OffersProductData: Codable{
    let store_name: String
    let price: String
    let offer_page_url: String!
}

//------------NEW API MODEL FOR REVIEWS---------------------//

struct ReviewResponse: Codable {
    let data: ReviewDataState
}

struct ReviewDataState: Codable {
    let reviews: [ReviewsProductData]
}

struct ReviewsProductData: Codable {
    let review_id: String
    let review_title: String?
    let review_author: String
   let review_source: String
    let review_text: String
    let rating: Float
//    let photos: [String]?
    let review_datetime_utc: String
}

