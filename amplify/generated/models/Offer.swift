// swiftlint:disable all
import Amplify
import Foundation

public struct Offer: Embeddable {
  var store_name: String
  var price: String
  var offer_page_url: String?
}