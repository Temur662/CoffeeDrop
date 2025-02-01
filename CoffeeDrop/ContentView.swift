//
//  ContentView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI

struct ContentView: View {
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

#Preview {
    ContentView()
}
