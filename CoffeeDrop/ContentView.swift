//
//  ContentView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI
/*
 Add Back Auth After
 */
struct ContentView: View {
    @EnvironmentObject var userProfile : UserProfile
    @State var isAuthenticated = false
      var body: some View {
        UserRootView()
       
     /* Group {
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
                if isAuthenticated {
                   await userProfile.fetchProfile()
                }
            }
          }
        }
      */
      }
}

#Preview {
    ContentView()
        .environmentObject(UserProfile())
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
