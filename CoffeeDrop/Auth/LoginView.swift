//
//  LoginView.swift
//  CoffeeDrop
//
//  Created by Temurbek Sayfutdinov on 2/2/25.
//

import SwiftUI
struct LoginView : View {
    @Environment(\.dismiss) private var dismiss
    @State var email = ""
    @State var isLoading = false
    @State var result: Result<Void, Error>?

    var body: some View {
      Form {
        Section {
          TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }

        Section {
          Button("Sign in") {
            signInButtonTapped()
          }

          if isLoading {
            ProgressView()
          }
        }
          NavigationLink(destination: SignUpView()){
              ZStack {
                  Circle()
                      .frame(width: 64, height: 64)
                      .foregroundStyle(Color(red: 0.54, green: 0.32, blue: 0.16))
                  Image(systemName: "arrow.right")
                      .font(Font.title.weight(.semibold))
                      .foregroundStyle(Color.white)
                      .frame(width: 40, height: 40)
              }
              .padding(.trailing, 35)
          }
          navigationBarBackButtonHidden(true)
          .toolbar {
              ToolbarItem(placement: .topBarLeading) {
                  Button(action: {
                      dismiss()
                  }) {
                      Label("Back", systemImage: "arrow.left")
                  }
              }
          }

        if let result {
          Section {
            switch result {
            case .success:
              Text("Check your inbox.")
            case .failure(let error):
              Text(error.localizedDescription).foregroundStyle(.red)
            }
          }
        }
      }
      .onOpenURL(perform: { url in
        Task {
          do {
              try await Constants.API.supabaseClient.auth.session(from: url)
          } catch {
            self.result = .failure(error)
          }
        }
      })
    }

    func signInButtonTapped() {
      Task {
        isLoading = true
        defer { isLoading = false }

        do {
            try await Constants.API.supabaseClient.auth.signInWithOTP(
              email: email,
              redirectTo: URL(string: "io.supabase.user-management://login-callback")
          )
          result = .success(())
        } catch {
          result = .failure(error)
        }
      }
    }
}
