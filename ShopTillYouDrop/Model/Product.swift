//
//  Price.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-26.
//

import Foundation

struct Product: Codable, Identifiable {
    let id = UUID()
    let title: String
    let img: String
    let price: String
    let shop: String
    
    

}
