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


    func createProductData() async {

        do{

            let model = ProductData(
                product_id: "Lorem ipsum dolor sit amet",
                product_title: "Lorem ipsum dolor sit amet",
                product_photos: [],
                product_rating: 123.45,
                product_description: "Lorem ipsum dolor sit amet",
                offer: Offer (
                    store_name: "Store Name1",
                    price: "$31.63",
                    offer_page_url: "example link"
                ))

            let savedProduct = try await Amplify.DataStore.save(model)
            print("Saved product: \(savedProduct)")

        }catch{
            print(error)
        }

    }



}
