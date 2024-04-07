// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "efabc47eaf648dd85f9430e73c615d59"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductDataState.self)
    ModelRegistry.register(modelType: User.self)
  }
}