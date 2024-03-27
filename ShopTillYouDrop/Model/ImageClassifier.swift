//
//  ImageClassifier.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-25.
//

import Foundation
import Foundation
import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
        
}
