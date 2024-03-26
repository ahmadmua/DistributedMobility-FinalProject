//
//  MainTab.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-22.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
            UserProfileView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
        }
    }
}
