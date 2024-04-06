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
    
    
    func createProductData(product_id: String, product_title: String, product_rating: Double, product_description: String, store_name: String, price: String, offer_page_url: String) async {
        
        do{
            
            let model = ProductData(
                product_id: product_id,
                product_title: product_title,
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
    
    func deleteAllProductData() async {
          do {
              try await Amplify.DataStore.clear()
          } catch {
              print("Error deleting all records: \(error)")
          }
      }

  }
    
    
