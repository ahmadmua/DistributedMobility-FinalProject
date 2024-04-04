//
//  Homepage.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-25.
//

import SwiftUI

struct Homepage: View {
    
    @State private var isShowingMenu = false
    @State private var menuWidth: CGFloat = 0
    @State private var selection: Int = 1
    
    var body: some View {
        
        
        NavigationView {
            
            
            ZStack(alignment: .leading) {

                Color.white
                
                TabView(selection: $selection) {
                    
                    UserProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("User")
                            
                        }
                        .tag(2)
                    
                    Scan()
                        .tabItem {
                            Image(systemName: "camera.fill")
                            Text("Scan")
                            
                        }
                        .tag(1)
                        
                    
                    WishlistView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Wishlist")
                        }
                        .tag(3)
                    
                    
                }


            }
            
            
        }        
                    .navigationBarItems(leading:
                        Button(action: {
                            withAnimation {
                                isShowingMenu.toggle()
                                   
                                
                            }
                        }) {
                            Image(systemName: "person.crop.circle.fill")
                        }
                    )
                    .onAppear {
                        menuWidth = UIScreen.main.bounds.width / 1.75
                    }
                    .navigationBarBackButtonHidden(true)
    }
}
