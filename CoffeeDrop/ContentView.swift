//
//  ContentView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI

struct ContentView: View {
    @State var isAuthenticated = false

      var body: some View {
        Group {
          if isAuthenticated {
            UserRootView()
          } else {
              AuthRootLayout()
          }
        }
        .task {
            for await state in Constants.API.supabaseClient.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) {
              isAuthenticated = state.session != nil
            }
          }
        }
      }
}

#Preview {
    ContentView()
}

/*TabView{
    Home()
        .tabItem{
            Label("Home", systemImage : "house")
        }
    MapTab()
        .tabItem{
            Label("Map", systemImage: "map")
        }
}*/
