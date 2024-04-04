//
//  ShopTillYouDropApp.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-21.
//

import Amplify
import SwiftUI
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin

@main
struct ShopTillYouDropApp: App {
    
    let classifier = ImageClassifier()
    let amplifyDBController = AmplifyDBController()
    
    init() {
        
        configureAmplify()
    }
    func configureAmplify() {
        do {
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Failed to initialize Amplify", error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SessionView().environmentObject(classifier).environmentObject(amplifyDBController)
        }
    }
}
