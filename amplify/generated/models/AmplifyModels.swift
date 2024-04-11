// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "9013eed60dba0dc7c1c62e15c2573d21"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductDataState.self)
    ModelRegistry.register(modelType: User.self)
  }
}