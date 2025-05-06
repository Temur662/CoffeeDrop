//
//  UserRootView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//  // Root EntryPoint View for the Users Once Logged in

import SwiftUI
import MapKit

struct UserRootView : View {
    @Namespace var animation
    
    @State var CurrentTab : Int = 0
    var body: some View {
        TabView(selection: $CurrentTab){
            Home(CurrentTab: $CurrentTab, animation: animation)
                .tabItem{
                    Label("Home", systemImage : "house")
                }
                .tag(0)
            
            
            MapTab(animation: animation)
                .tabItem{
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            
            Wallet()
                .tabItem{
                    Label("Wallet", systemImage: "wallet.bifold")
                }
                .tag(2)
            
            SocialTabView()
                .tabItem {
                    Image("SocialFace")
                    Text("Social")
                }
        }
    }
}
