//
//  CoffeeDropApp.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import SwiftUI

@main
struct CoffeeDropApp: App {
    @StateObject private var userProfile = UserProfile()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userProfile) //  Makes User Profile available through out the app
        }
    }
}
