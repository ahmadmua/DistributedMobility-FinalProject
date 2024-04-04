// swiftlint:disable all
import Amplify
import Foundation

extension Offer {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case store_name
    case price
    case offer_page_url
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let offer = Offer.keys
    
    model.listPluralName = "Offers"
    model.syncPluralName = "Offers"
    
    model.fields(
      .field(offer.store_name, is: .required, ofType: .string),
      .field(offer.price, is: .required, ofType: .string),
      .field(offer.offer_page_url, is: .optional, ofType: .string)
    )
    }
}