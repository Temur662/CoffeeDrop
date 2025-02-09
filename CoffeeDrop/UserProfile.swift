//
//  UserProfile.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/4/25.
//  ObservableObject for a User's profile

import SwiftUI
import Auth
import Combine
import PostgREST
import MapKit
struct UserProfileData: Decodable {
    let user_id : UUID
    let email: String?
    let user_name: String?
    let phone_number : String?
    var is_auth : Bool?
}
class UserProfile: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userProfile: UserProfileData? = nil
    @State private var updateUserResult : Result<Void,Error>?
    @Published var newEmail : String = ""
    @Published var newPassword : String = ""
    @Published var userLocation : MapCameraPosition?
    func SignOut() {
        Task{
            do{
                isAuthenticated = false
                userProfile = nil
                try await Constants.API.supabaseClient.auth.signOut()
            }
        }
    }
    // You can add signOut, fetchProfile, etc.
    
    func fetchProfile() async {
        do {
            let currentUser = try await Constants.API.supabaseClient.auth.session.user
            
            let profile : UserProfileData = try await Constants.API.supabaseClient
                .from("profiles")
                .select()
                .eq("user_id", value: currentUser.id)
                .single()
                .execute()
                .value
            userProfile = profile
            
            if profile.is_auth == false {
                try await Constants.API.supabaseClient.auth.update(user: UserAttributes(email: newEmail, password: newPassword))
                print(newEmail, newPassword)
                let response : PostgrestResponse<Void> = try await Constants.API.supabaseClient
                    .from("profiles")
                    .update(["is_auth" : true])
                    .eq("user_id", value: currentUser.id)
                    .execute()
                if response.data.isEmpty {
                    userProfile?.is_auth = true
                }
            }
        }
        catch{
            debugPrint(error)
        }
    }
}
