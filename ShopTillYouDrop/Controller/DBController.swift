//
//  DBController.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-04-19.
//

import Foundation
import Amplify

class DBController {
    
    
    func createProductData(product: Product, offers: [OffersProductData], reviews: [ReviewsProductData], userState: UserState) async {
        do {
            var offerLinks: [OfferLinkStates] = []
            
            for product in offers {
                let offerLink = OfferLinkStates(store_name: product.store_name, price: product.price, offer_page_url: product.offer_page_url)
                offerLinks.append(offerLink)
            }
            
            var reviewLinks: [ReviewLinkStates] = []
            
            for rev in reviews {
                let reviewLink = ReviewLinkStates(review_id: rev.review_id, review_title: rev.review_title, review_author: rev.review_author, review_source: rev.review_source, review_text: rev.review_text, rating: Double(rev.rating), review_datetime_utc: rev.review_datetime_utc)
                reviewLinks.append(reviewLink)
            }
            
            let model = ProductDataState(
                product_id: product.product_id,
                product_title: product.product_title,
                userId: userState.userId,
                product_description: product.product_description,
                product_rating: product.product_rating,
                offer: OfferDataState(store_name: product.offer.store_name, price: product.offer.price, offer_page_url: product.offer.offer_page_url),
                product_photos: product.product_photos,
                typical_price_range: product.typical_price_range,
                offerLink: offerLinks,
                reviewLink: reviewLinks
            )
            
            _ = try await Amplify.DataStore.save(model)
            
        } catch {
            print(error)
        }
    }
    
    func uploadImageToS3(urlString: String, product: Product) async {
        guard let imageUrl = URL(string: urlString) else {
            return
        }

        do {
            let imageData =  try await Data(contentsOf: imageUrl)
            let uuid = product.product_id
            let key = "\(uuid).jpg"

            let result = try await Amplify.Storage.uploadData(
                key: key,
                data: imageData
            ).value

            print("Image uploaded to S3 with key:", result)
        } catch {
            print("Error uploading image to S3:", error)
        }
    }
    
    
    
    
}
