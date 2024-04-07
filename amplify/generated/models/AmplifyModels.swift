// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "eb30cbb3dcfb5c6b846ef5867ba0995e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductDataState.self)
    ModelRegistry.register(modelType: User.self)
  }
}