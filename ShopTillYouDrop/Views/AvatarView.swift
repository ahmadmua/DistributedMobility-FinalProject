////
////  AvatarView.swift
////  ShopTillYouDrop
////
////  Created by Muaz on 2024-03-22.
////
//
//import Foundation
//import AmplifyImage
//import SwiftUI
//// 1
//enum AvatarState: Equatable {
//    case remote(avatarKey: String)
//    case local(image: UIImage)
//}
//struct AvatarView: View {
//    let state: AvatarState
//    // 2
//    let fromMemoryCache: Bool
//
//    var body: some View {
//        // 1
//        switch state {
//        case .remote(let avatarKey):
//            // 2
//            AmplifyImage(key: avatarKey)
//                // 3
//                .kfImage
//                .placeholder {
//                    Image(systemName: "person")
//                        .resizable()
//                        .foregroundColor(.purple)
//                        .padding(8)
//                        .background(Color.init(white: 0.9))
//                        .clipShape(Circle())
//                }
//                // 4
//                .fromMemoryCacheOrRefresh(fromMemoryCache)
//                // 5
//                .scaleToFillWidth()
//                .clipShape(Circle())
//
//        // 6
//        case .local(let image):
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFill()
//                .clipShape(Circle())
//        }
//    }
//
//    // 3
//    init(state: AvatarState, fromMemoryCache: Bool = false) {
//        self.state = state
//        self.fromMemoryCache = fromMemoryCache
//    }
//}
