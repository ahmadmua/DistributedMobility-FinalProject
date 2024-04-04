// swiftlint:disable all
import Amplify
import Foundation

public struct ProductData: Model {
  public let id: String
  public var product_id: String
  public var product_title: String
  public var product_photos: [String]?
  public var product_rating: Double?
  public var product_description: String?
  public var offer: Offer?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      product_id: String,
      product_title: String,
      product_photos: [String]? = nil,
      product_rating: Double? = nil,
      product_description: String? = nil,
      offer: Offer? = nil) {
    self.init(id: id,
      product_id: product_id,
      product_title: product_title,
      product_photos: product_photos,
      product_rating: product_rating,
      product_description: product_description,
      offer: offer,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      product_id: String,
      product_title: String,
      product_photos: [String]? = nil,
      product_rating: Double? = nil,
      product_description: String? = nil,
      offer: Offer? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.product_id = product_id
      self.product_title = product_title
      self.product_photos = product_photos
      self.product_rating = product_rating
      self.product_description = product_description
      self.offer = offer
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}