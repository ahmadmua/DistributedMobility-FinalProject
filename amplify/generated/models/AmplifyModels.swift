// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "72b3190d9ee51889ade454d69ecd3e06"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ProductDataState.self)
    ModelRegistry.register(modelType: User.self)
  }
}