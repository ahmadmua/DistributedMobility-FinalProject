//
//  AmplifyDBController.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-04-03.
//

import Amplify
import AWSPluginsCore
import Foundation

class AmplifyDBController: ObservableObject {
    
    
    func createProductData(product_id: String, product_title: String, product_photos: [String], product_rating: Double, product_description: String, store_name: String, price: String, offer_page_url: String) async {
        
        do{
            
            let model = ProductData(
                product_id: product_id,
                product_title: product_title,
                product_photos: product_photos,
                product_rating: product_rating,
                product_description: product_description,
                offer: Offer (
                    store_name: store_name,
                    price: price,
                    offer_page_url: offer_page_url
                ))
            
            let savedProduct = try await Amplify.DataStore.save(model)
            //print("Saved product: \(savedProduct)")
            
        }catch{
            print(error)
        }
        
    }
    
    func readProductData() async {
        
        do {
            
            let todos = try await Amplify.DataStore.query(ProductData.self)
            for todo in todos {
                print("==== Product DATA ====")
                print("Name: \(todo.product_title)")
                print("Product ID: \(todo.product_id)")
            }
        } catch {
            print(error)
        }
        
        
    }
    
    
    
    
    
}
