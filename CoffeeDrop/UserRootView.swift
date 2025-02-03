//
//  UserRootView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//  // Root EntryPoint View for the Users Once Logged in

import SwiftUI
struct UserRootView : View {
    var body: some View {
        TabView{
            Home()
                .tabItem{
                    Label("Home", systemImage : "house")
                }
            MapTab()
                .tabItem{
                    Label("Map", systemImage: "map")
                }
        }
    }
}

