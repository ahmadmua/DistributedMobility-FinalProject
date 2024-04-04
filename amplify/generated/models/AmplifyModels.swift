// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "0998e5caa17494f302b94b5c4658af3e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductData.self)
    ModelRegistry.register(modelType: User.self)
  }
}