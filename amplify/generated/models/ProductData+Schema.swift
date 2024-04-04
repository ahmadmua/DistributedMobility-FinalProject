// swiftlint:disable all
import Amplify
import Foundation

extension ProductData {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case product_id
    case product_title
    case product_photos
    case product_rating
    case product_description
    case offer
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let productData = ProductData.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "ProductData"
    model.syncPluralName = "ProductData"
    
    model.attributes(
      .primaryKey(fields: [productData.id])
    )
    
    model.fields(
      .field(productData.id, is: .required, ofType: .string),
      .field(productData.product_id, is: .required, ofType: .string),
      .field(productData.product_title, is: .required, ofType: .string),
      .field(productData.product_photos, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(productData.product_rating, is: .optional, ofType: .double),
      .field(productData.product_description, is: .optional, ofType: .string),
      .field(productData.offer, is: .optional, ofType: .embedded(type: Offer.self)),
      .field(productData.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(productData.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension ProductData: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}